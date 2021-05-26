import 'package:flutter/material.dart';
import 'package:youcomic/components/book_item.dart';

import '../provider.dart';

class SearchBooksTab extends StatelessWidget {
  final SearchProvider provider;

  SearchBooksTab({this.provider});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    createBookItem(book) {
      items.add(Container(
        padding: EdgeInsets.all(8),
        child: BookItem(book: book),
      ));
    }

    provider.bookDataSource.books.forEach((book) => createBookItem(book));
    ScrollController _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel) {
        provider.onLoadMoreBook();
      } else {}
    });
    return ListView(
      controller: _controller,
      children: items,
    );
  }
}
