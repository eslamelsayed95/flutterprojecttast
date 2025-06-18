// lib/domain/usecases/get_books.dart
import 'package:injectable/injectable.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

@lazySingleton
class GetBooks {
  final BookRepository repository;
  GetBooks(this.repository);

  Future<List<Book>> call({required int page}) {
    return repository.getBooks(page: page);
  }
}
