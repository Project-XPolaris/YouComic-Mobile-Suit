import 'package:flutter/material.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/components/book_card.dart';
import 'package:youcomic/components/horizon_card_collection.dart';

class BookHorizonCollection extends StatelessWidget {
  final List<BookEntity> books;
  final String title;
  BookHorizonCollection({required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    return HorizonCardCollection(
      title: title,
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
