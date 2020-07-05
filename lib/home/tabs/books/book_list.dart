import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/book_info_bottom_sheet.dart';
import 'package:youcomic/components/book_item.dart';
import 'package:youcomic/home/tabs/books/provider.dart';

class BookListPage extends StatelessWidget {
  final BookListProvider externalBookListProvider;

  BookListPage({this.externalBookListProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListProvider>.value(
      value: externalBookListProvider,
      child: Consumer<BookListProvider>(
          builder: (context, bookListProvider, builder) {
        Future _pullToRefresh() async {
          await bookListProvider.loadBooks(true);
        }

        bookListProvider.loadBooks(false);

        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            bookListProvider.loadMore();
          } else {}
        });
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView.separated(
              itemCount: bookListProvider.dataSource.books.length,
              itemBuilder: (context, idx) {
                return BookItem(
                  book: bookListProvider.dataSource.books[idx],
                  onLongPress: () {
                    HapticFeedback.vibrate();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return BookInfoBottomSheet(
                            bookEntity: bookListProvider.dataSource.books[idx],
                          );
                        });
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 0,
              ),
              controller: _controller,
            ),
          ),
        );
      }),
    );
  }
}
