// lib/domain/usecases/search_books.dart
import 'package:injectable/injectable.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

@lazySingleton
class SearchBooks {
  final BookRepository repository;
  SearchBooks(this.repository);

  Future<List<Book>> call({required String query, required int page}) {
    return repository.searchBooks(query: query, page: page);
  }
}
