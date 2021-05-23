import 'package:flutter/material.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/components/book_card.dart';
import 'package:youcomic/components/horizon_card_collection.dart';

class BookHorizonCollection extends StatelessWidget {
  final List<BookEntity> books;

  BookHorizonCollection({this.books});

  @override
  Widget build(BuildContext context) {
    final _cards = books
        .map((book) => Padding(
              padding: EdgeInsets.only(right: 8),
              child: BookCard(book: book),
            ))
        .toList();
    return HorizonCardCollection(
      title: "最近添加",
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: books.map((book) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: BookCard(book:book),
          );
        }).toList(),
      ),
    );
  }
}
