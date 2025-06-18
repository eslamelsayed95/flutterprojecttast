// lib/data/models/book_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<AuthorModel> authors;

  @HiveField(3)
  final BookFormatsModel formats;

  BookModel(
      {required this.id,
      required this.title,
      required this.authors,
      required this.formats});

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class AuthorModel extends HiveObject {
  @HiveField(0)
  final String name;

  AuthorModel({required this.name});
  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class BookFormatsModel extends HiveObject {
  @JsonKey(name: 'image/jpeg')
  @HiveField(0)
  final String? imagejpeg;

  BookFormatsModel({this.imagejpeg});
  factory BookFormatsModel.fromJson(Map<String, dynamic> json) =>
      _$BookFormatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookFormatsModelToJson(this);
}

extension BookModelX on BookModel {
  Book toEntity() {
    return Book(
      id: id,
      title: title, // Maps the book's title
      author: authors.map((a) => a.name).join(', '), // Maps the author(s)
      coverUrl: formats.imagejpeg ?? '', // Maps the cover image URL
      summary:
          "This is a placeholder summary. The full summary is not provided by the list API endpoint but this demonstrates the expand/collapse functionality as required.",
    );
  }
}
