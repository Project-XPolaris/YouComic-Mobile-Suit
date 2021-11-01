import 'package:flutter/material.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/pages/tag/tag.dart';
import 'package:youcomic/util/book.dart';

class BookInfoBottomSheet extends StatefulWidget {
  final BookEntity bookEntity;

  BookInfoBottomSheet({required this.bookEntity});

  @override
  _BookInfoBottomSheetState createState() => _BookInfoBottomSheetState();
}

class _BookInfoBottomSheetState extends State<BookInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final TagEntity? artistTag =
        getBookTag(bookEntity: this.widget.bookEntity, tagType: "artist");
    final TagEntity? seriesTag =
        getBookTag(bookEntity: this.widget.bookEntity, tagType: "series");
    final TagEntity? themeTag =
        getBookTag(bookEntity: this.widget.bookEntity, tagType: "theme");
    final TagEntity? translatorTag =
        getBookTag(bookEntity: this.widget.bookEntity, tagType: "translator");
    return Wrap(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
              child: Text(
                this.widget.bookEntity.name,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
            ),
            Divider(
              height: 0,
            ),
            artistTag != null
                ? BookInfoItem(
                    text: "Artist: ${artistTag.name}",
                    onTap: () {
                      Navigator.of(context).pop();
                      TagPage.launch(context, artistTag);
                    },
                    icon: Icon(Icons.person),
                  )
                : Container(),
            seriesTag != null
                ? BookInfoItem(
                    text: "Series: ${seriesTag.name}",
                    onTap: () {
                      Navigator.of(context).pop();
                      TagPage.launch(context, seriesTag);
                    },
                    icon: Icon(Icons.book))
                : Container(),
            themeTag != null
                ? BookInfoItem(
                    text: "Theme: ${themeTag.name}",
                    onTap: () {
                      Navigator.of(context).pop();
                      TagPage.launch(context, themeTag);
                    },
                    icon: Icon(Icons.sentiment_very_satisfied))
                : Container(),
            translatorTag != null
                ? BookInfoItem(
                    text: "Theme: ${translatorTag.name}",
                    onTap: () {
                      Navigator.of(context).pop();
                      TagPage.launch(context, translatorTag);
                    },
                    icon: Icon(Icons.translate))
                : Container()
          ],
        )
      ],
    );
  }
}

class BookInfoItem extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Icon icon;

  BookInfoItem({required this.text, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 16),
                    child: icon,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
