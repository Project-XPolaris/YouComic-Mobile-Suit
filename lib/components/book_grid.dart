import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youui/components/gridview.dart';

import '../pages/detail/detail.dart';

class BookGrid extends StatelessWidget {
  final List<BookEntity> books;
  final ScrollController? controller;
  final Function(BookEntity book)? onLongPress;
  final int itemWidth;

  const BookGrid(
      {Key? key, required this.books, this.controller, this.onLongPress,this.itemWidth = 180})
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
      itemWidth: itemWidth,
      aspectRatio: 9 / 16,
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
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
              margin: EdgeInsets.only(top: 4),
              height: 16,
              child: Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 16,
              child: Text(
                book.displayAuthor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),fontSize: 12),
              ),
            ),
            Container(
              height: 16,
              margin: EdgeInsets.only(top: 4),
              child: Text(
                  book.displayTheme,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),fontSize: 12)
              ),
            ),
            Container(
              height: 16,
              margin: EdgeInsets.only(top: 4),
              child: Text(
                  book.displaySeries,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),fontSize: 12)
              ),
            ),
            Container(
              height: 16,
              margin: EdgeInsets.only(top: 4),
              child: Text(
                  "${book.pageCount}P",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),fontSize: 12)
              ),
            )
          ],
        ),
      ),
    );
  }
}
