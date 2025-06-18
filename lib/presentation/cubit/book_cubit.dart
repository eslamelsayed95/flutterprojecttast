// lib/presentation/cubit/book_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/search_books.dart';

part 'book_state.dart';

@injectable
class BookCubit extends Cubit<BookState> {
  final GetBooks _getBooks;
  final SearchBooks _searchBooks;

  BookCubit(this._getBooks, this._searchBooks) : super(const BookState());

  Future<void> fetchOrSearchBooks() async {
    if (state.hasReachedMax || state.status == BookStatus.loading) return;

    emit(state.copyWith(status: BookStatus.loading));

    try {
      final newBooks =
          state.currentQuery != null && state.currentQuery!.isNotEmpty
              ? await _searchBooks(query: state.currentQuery!, page: state.page)
              : await _getBooks(page: state.page);

      if (newBooks.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, status: BookStatus.success));
      } else {
        emit(state.copyWith(
          status: BookStatus.success,
          books: List.of(state.books)..addAll(newBooks),
          page: state.page + 1,
          hasReachedMax: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: BookStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;
    emit(BookState(currentQuery: query, page: 1));
    await fetchOrSearchBooks();
  }

  Future<void> clearSearch() async {
    emit(const BookState(page: 1));
    await fetchOrSearchBooks();
  }
}
