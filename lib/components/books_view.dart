import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/model/book_entity.dart';
import 'book_grid.dart';
import 'book_info_bottom_sheet.dart';
import 'book_item.dart';

class BooksView extends StatelessWidget {
  final List<BookEntity> books;
  final String viewMode;
  final ScrollController? controller;
  final int itemWidth;
  const BooksView({Key? key,required this.books,required this.viewMode,this.controller,this.itemWidth = 180}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    onBookLongPress(BookEntity book) {
      HapticFeedback.vibrate();
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return BookInfoBottomSheet(
                bookEntity: book
            );
          });
    }
    if (viewMode == "List") {
      return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, idx) {
          return Container(
            padding: EdgeInsets.all(8),
            child: BookItem(
              book: books[idx],
              onLongPress: () {
                onBookLongPress(
                    books[idx]
                );
              },
            ),
          );
        },
        controller: controller,
      );
    }
    return BookGrid(
      books: books,
      controller: controller,
      onLongPress: onBookLongPress,
      itemWidth: itemWidth,
    );
  }
}
