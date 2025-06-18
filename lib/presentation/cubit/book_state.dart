// lib/presentation/cubit/book_state.dart
part of 'book_cubit.dart';

enum BookStatus { initial, loading, success, failure }

class BookState extends Equatable {
  final BookStatus status;
  final List<Book> books;
  final String? currentQuery;
  final int page;
  final bool hasReachedMax;
  final String? errorMessage;

  const BookState({
    this.status = BookStatus.initial,
    this.books = const <Book>[],
    this.currentQuery,
    this.page = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  BookState copyWith({
    BookStatus? status,
    List<Book>? books,
    String? currentQuery,
    int? page,
    bool? hasReachedMax,
    String? errorMessage,
    bool clearQuery = false,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      currentQuery: clearQuery ? null : currentQuery ?? this.currentQuery,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, books, currentQuery, page, hasReachedMax, errorMessage];
}
