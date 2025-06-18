// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart'; // Fixed import path
import 'presentation/cubit/book_cubit.dart';
import 'presentation/screens/book_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BookCubit>(), // Sets up the Cubit for state management
      child: MaterialApp(
        title: 'Gutendex Book App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const BookListScreen(), // Sets the main screen of the application
      ),
    );
  }
}
