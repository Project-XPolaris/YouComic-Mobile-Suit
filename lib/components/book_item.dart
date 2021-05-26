import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/pages/detail/detail.dart';
import 'package:youcomic/util/book.dart';

class BookItem extends StatelessWidget {
  final BookEntity book;
  final Function onLongPress;

  BookItem({this.book, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DetailPage.launch(context, book);
      },
      onLongPress: this.onLongPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                width: 96,
                height: 150,
                fit: BoxFit.cover,
                httpHeaders: {"Authorization": ApiClient().token},
                imageUrl: book.cover,
                placeholder: (context, url) => Container(color: Colors.black12,),
                errorWidget: (context, url, error) => Container(color: Colors.black12,),
              ),
          ),

          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Container(
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text(
                          book.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          getBookTagName(
                              bookEntity: book,
                              tagType: "artist",
                              defaultText: ""),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          getBookTagName(
                              bookEntity: book,
                              tagType: "series",
                              defaultText: ""),
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          getBookTagName(
                              bookEntity: book,
                              tagType: "theme",
                              defaultText: ""),
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
