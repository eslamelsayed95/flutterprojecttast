// lib/data/datasources/local_data_source.dart
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/book_model.dart';

const String booksBoxKey = 'booksBox';
const String searchBoxKeyPrefix = 'searchBox_';

@lazySingleton
class LocalDataSource {
  Future<void> cacheBooks(List<BookModel> books, String? query) async {
    final boxKey = query == null || query.isEmpty
        ? booksBoxKey
        : '$searchBoxKeyPrefix$query';
    final box = await Hive.openBox<BookModel>(boxKey);
    final Map<int, BookModel> bookMap = {for (var book in books) book.id: book};
    await box.putAll(bookMap);
  }

  Future<List<BookModel>> getCachedBooks(String? query) async {
    final boxKey = query == null || query.isEmpty
        ? booksBoxKey
        : '$searchBoxKeyPrefix$query';
    if (!Hive.isBoxOpen(boxKey)) {
      await Hive.openBox<BookModel>(boxKey);
    }
    final box = Hive.box<BookModel>(boxKey);
    return box.values.toList();
  }
}
