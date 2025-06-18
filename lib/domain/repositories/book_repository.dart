// lib/domain/repositories/book_repository.dart
import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks({required int page});
  Future<List<Book>> searchBooks({required String query, required int page});
}
