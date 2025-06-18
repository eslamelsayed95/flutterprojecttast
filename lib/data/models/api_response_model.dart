// api_response_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'book_model.dart';

part 'api_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiResponseModel {
  final int count;
  final String? next;
  final List<BookModel> results;

  ApiResponseModel({required this.count, this.next, required this.results});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}
