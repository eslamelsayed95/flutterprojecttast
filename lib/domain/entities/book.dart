// lib/domain/entities/book.dart
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String summary;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.summary,
  });

  @override
  List<Object?> get props => [id, title, author, coverUrl];
}
