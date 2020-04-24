import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/book_item.dart';
import 'package:youcomic/providers/search.dart';

class SearchBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, provider, builder) {
      List<Widget> items = [];
      createBookItem(book) {
        items.add(BookItem(book:book));
        items.add(Divider(
          height: 0,
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
    });
  }
}
