import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/detail/components/book_collection.dart';
import 'package:youcomic/pages/detail/provider.dart';
import 'package:youcomic/pages/detail/select_collection_bottom_sheet.dart';
import 'package:youcomic/pages/read/read.dart';
import 'package:youcomic/pages/tag/tag.dart';

import 'components/detail_section.dart';

class DetailPage extends StatelessWidget {
  final BookEntity book;

  DetailPage({required this.book});

  static launch(BuildContext context, BookEntity book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey sc = new GlobalKey();

    return ChangeNotifierProvider(
      create: (_) => DetailProvider(book: this.book),
      child:
          Consumer<DetailProvider>(builder: (context, detailProvider, builder) {
        detailProvider.onLoad();
        onReadButtonClick() {
          var id = detailProvider.book.id;
          if (id == null) {
            return;
          }
          ReadPage.launch(context, id);
        }

        var tags = detailProvider.tags
            .map((tag) => Padding(
                  padding: EdgeInsets.only(right: 8, bottom: 2),
                  child: ActionChip(
                    label: Text(tag.getName()),
                    onPressed: () => TagPage.launch(context, tag),
                  ),
                ))
            .toList();
        renderRelateArtist() {
          if (detailProvider.relateArtistBookDataSource.books.length > 0) {
            return [
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  child: DetailSection(
                    title: "Author",
                    child: Container(
                      width: double.infinity,
                      height: 260,
                      child: RelateBooksHorizonCollection(
                        books: detailProvider.relateArtistBookDataSource.books,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
            ];
          }
          return [];
        }

        renderRelateSeries() {
          if (detailProvider.relateSeriesBookDataSource.books.length > 0) {
            return [
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  child: DetailSection(
                    title: "Series",
                    child: Container(
                      width: double.infinity,
                      height: 260,
                      child: RelateBooksHorizonCollection(
                        books: detailProvider.relateSeriesBookDataSource.books,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
            ];
          }
          return [];
        }

        renderRelateTheme() {
          if (detailProvider.relateThemeBookDataSource.books.length > 0) {
            return [
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  child: DetailSection(
                    title: "Theme",
                    child: Container(
                      width: double.infinity,
                      height: 260,
                      child: RelateBooksHorizonCollection(
                        books: detailProvider.relateThemeBookDataSource.books,
                      ),
                    ),
                  ),
                ),
              )
            ];
          }
          return [];
        }

        List<Widget> renderAction() {
          if (ApplicationConfig().useNanoMode) {
            return [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: FlatButton(
                      color: Colors.blue,
                      child: Text(
                        "阅读",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onReadButtonClick,
                    ),
                  )),
            ];
          }
          return [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text(
                      "阅读",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: onReadButtonClick,
                  ),
                )),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: OutlineButton(
                    child: Text("加入收藏"),
                    onPressed: () {
                      detailProvider.loadCollections();
                      var buildContext = sc.currentContext;
                      if (buildContext != null) {
                        Scaffold.of(buildContext).showBottomSheet((context) {
                          return SelectCollectionBottomSheet();
                        });
                      }
                    },
                  ),
                ))
          ];
        }

        var cover = detailProvider.cover;
        return Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text(
                detailProvider.book.name,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            body: SingleChildScrollView(
              key: sc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          cover != null
                              ? CachedNetworkImage(
                                  width: 120,
                                  httpHeaders: {
                                    "Authorization": ApiClient().token
                                  },
                                  imageUrl: cover,
                                )
                              : Container(),
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Wrap(
                                  children: <Widget>[
                                    Text(
                                      detailProvider.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(detailProvider.artist),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    detailProvider.series,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    detailProvider.theme,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: <Widget>[...renderAction()],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 24, bottom: 24),
                    child: DetailSection(
                      title: "Tags",
                      child: Wrap(
                        children: tags,
                      ),
                    ),
                  ),
                  Divider(),
                  ...renderRelateArtist(),
                  ...renderRelateSeries(),
                  ...renderRelateTheme()
                ],
              ),
            ));
      }),
    );
  }
}
