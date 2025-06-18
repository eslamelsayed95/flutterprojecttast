// lib/data/repositories/book_repository_impl.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/book_model.dart';
import '../models/api_response_model.dart';

@Injectable()
class BookRepositoryImpl implements BookRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Connectivity connectivity;

  BookRepositoryImpl(
      this.remoteDataSource, this.localDataSource, this.connectivity);

  @override
  Future<List<Book>> getBooks({required int page}) async {
    return _getBooksInternal(
      page: page,
      fetcher: (p) => remoteDataSource.getBooks(p),
      query: null,
    );
  }

  @override
  Future<List<Book>> searchBooks(
      {required String query, required int page}) async {
    return _getBooksInternal(
      page: page,
      fetcher: (p) => remoteDataSource.searchBooks(query, p),
      query: query,
    );
  }

  Future<List<Book>> _getBooksInternal({
    required int page,
    required Future<ApiResponseModel> Function(int) fetcher,
    String? query,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    if (isConnected) {
      try {
        final apiResponse = await fetcher(page);
        if (page == 1) {
          final boxKey = query == null || query.isEmpty
              ? booksBoxKey // From local_data_source.dart
              : '$searchBoxKeyPrefix$query'; // From local_data_source.dart
          // Ensure the box is open and then clear it
          final Box<BookModel> box = await Hive.openBox<BookModel>(boxKey);
          await box.clear();
        }
        await localDataSource.cacheBooks(apiResponse.results, query);
        return apiResponse.results.map((model) => model.toEntity()).toList();
      } catch (e) {
        // Attempt to return cached data on API error if available
        final cachedBooks = await localDataSource.getCachedBooks(query);
        if (cachedBooks.isNotEmpty) {
          return cachedBooks.map((model) => model.toEntity()).toList();
        }
        // Rethrow or handle specific exceptions as needed
        throw Exception('Failed to load books: ${e.toString()}');
      }
    } else {
      // No internet connection, try to load from cache
      final cachedBooks = await localDataSource.getCachedBooks(query);
      if (cachedBooks.isNotEmpty) {
        return cachedBooks.map((model) => model.toEntity()).toList();
      }
      throw Exception('No Internet Connection and no cache available.');
    }
  }
}
