import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/pages/detail/detail.dart';

class BookCard extends StatelessWidget {
  final BookEntity book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    List<TagEntity> bookTags = this.book.tags;
    var authorTag = null;
    if (bookTags.length > 0) {
      authorTag = bookTags.firstWhere((tag) => tag.type == "artist");
    }
    var authorName = "未知";
    if (authorTag != null) {
      authorName = authorTag.name;
    }
    onCardClick() {
      DetailPage.launch(context, book);
    }
    var coverUrl = book.cover;
    return Container(
      width: 130,
      child: Card(
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () {
              onCardClick();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                coverUrl != null ? Image(
                  width: 130,
                  height: 180,
                  fit: BoxFit.cover,
                  image: NetworkImage(coverUrl,
                      headers: {"Authorization": "${ApiClient().token}"}),
                  errorBuilder: (b,s,e) {
                    return Container();
                  },
                ) : Container(
                  width: 130,
                  height: 180,
                  color: Colors.black12,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Text(
                    book.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2, left: 8),
                  child: Text(
                    authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
