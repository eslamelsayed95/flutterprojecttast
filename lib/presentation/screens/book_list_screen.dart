// lib/presentation/screens/book_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/book_cubit.dart';
import 'widgets/book_list_item.dart';
import 'widgets/search_bar_widget.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BookCubit>().fetchOrSearchBooks();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // _isBottom already checks _scrollController.hasClients
    if (!_isBottom) return;

    final cubit = context.read<BookCubit>();
    // Prevent multiple calls if already loading the next page or if max items have been reached.
    if (cubit.state.status != BookStatus.loading &&
        !cubit.state.hasReachedMax) {
      cubit.fetchOrSearchBooks();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gutenberg Project Books'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SearchBarWidget(),
        ),
      ),
      body: BlocBuilder<BookCubit, BookState>(
        builder: (context, state) {
          if (state.status == BookStatus.initial && state.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == BookStatus.failure && state.books.isEmpty) {
            return Center(
                child: Text('Failed to fetch books: ${state.errorMessage}'));
          }
          if (state.books.isEmpty && state.status != BookStatus.loading) {
            return const Center(child: Text('No books found.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.books.length
                : state.books.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.books.length) {
                // Show loader at the bottom only if not reached max and loading more
                // Or if it's the initial load for the next page
                return (state.status == BookStatus.loading &&
                        !state.hasReachedMax)
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              return BookListItem(book: state.books[index]);
            },
          );
        },
      ),
    );
  }
}
