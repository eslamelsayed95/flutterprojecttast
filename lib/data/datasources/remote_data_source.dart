// lib/data/datasources/remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/api_response_model.dart';

@lazySingleton
class RemoteDataSource {
  final Dio _dio;
  RemoteDataSource(this._dio);

  Future<ApiResponseModel> getBooks(int page) async {
    final response = await _dio.get('/books', queryParameters: {'page': page});
    return ApiResponseModel.fromJson(response.data);
  }

  Future<ApiResponseModel> searchBooks(String query, int page) async {
    final response = await _dio
        .get('/books', queryParameters: {'search': query, 'page': page});
    return ApiResponseModel.fromJson(response.data);
  }
}
