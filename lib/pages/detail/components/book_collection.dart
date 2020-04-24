import 'package:flutter/cupertino.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/components/book_card.dart';

class RelateBooksHorizonCollection extends StatelessWidget {
  final List<BookEntity> books;

  RelateBooksHorizonCollection({this.books});

  @override
  Widget build(BuildContext context) {
    final _cards = books
        .map((book) => Padding(
              padding: EdgeInsets.only(right: 8),
              child: BookCard(book: book),
            ))
        .toList();
    return ListView(
      scrollDirection: Axis.horizontal,
      children: _cards,
    );
  }
}
