import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youui/components/gridview.dart';

import '../pages/detail/detail.dart';

class BookGrid extends StatelessWidget {
  final List<BookEntity> books;
  final ScrollController? controller;
  final Function(BookEntity book)? onLongPress;

  const BookGrid(
      {Key? key, required this.books, this.controller, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        ...books.map((book) => BookGridItem(
              book: book,
              onLongPress: onLongPress,
            ))
      ],
      itemWidth: 220,
      aspectRatio: 180 / (220 + 16 + 16 + 8),
      controller: controller,
    );
  }
}

class BookGridItem extends StatelessWidget {
  final BookEntity book;
  final Function(BookEntity book)? onLongPress;

  const BookGridItem({Key? key, required this.book, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DetailPage.launch(context, book);
      },
      child: Container(
        width: 180,
        height: 220 + 16 + 16 + 8,
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              height: 220,
              child: Center(
                child: ClipRRect(
                  child: Image.network(
                    book.cover ?? "",
                    fit: BoxFit.contain,
                    headers: {"Authorization": "${ApiClient().token}"},
                    // height: 180 * StandardPageRatio,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              height: 16,
              child: Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: 16,
              child: Text(
                book.displayAuthor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
