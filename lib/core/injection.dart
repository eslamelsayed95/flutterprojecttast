// lib/core/injection.dart (not lib/core/di/injection.dart)
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gutendex_app/data/models/book_model.dart';
import 'package:gutendex_app/data/models/api_response_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await Hive.initFlutter();

  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(AuthorModelAdapter());
  Hive.registerAdapter(BookFormatsModelAdapter());

  // Registers Dio for network calls to the Gutendex API
  getIt.registerLazySingleton<Dio>(
      () => Dio(BaseOptions(baseUrl: 'https://gutendex.com')));
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  await getIt.init(); // Ensure all injectable dependencies are initialized
}
