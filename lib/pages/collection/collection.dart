import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/components/book_info_bottom_sheet.dart';
import 'package:youcomic/components/book_item.dart';
import 'package:youcomic/pages/collection/provider.dart';
import 'package:youcomic/home/tabs/favourite/provider.dart';

class CollectionDetailPage extends StatelessWidget {
  final CollectionEntity collection;

  CollectionDetailPage({required this.collection});

  static launch(BuildContext context, collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionDetailPage(
                collection: collection,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CollectionDetailProvider>(
      create: (_) => CollectionDetailProvider(collection: collection),
      child: Consumer<CollectionDetailProvider>(
          builder: (context, collectionDetailProvider, builder) {
        collectionDetailProvider.onLoad();
        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            collectionDetailProvider.onLoadMore();
          }
        });
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            title: Text(
              "收藏夹",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: ListView.separated(
            controller: _controller,
            separatorBuilder: (context, index) => Divider(
              height: 0,
            ),
            itemCount: collectionDetailProvider.dataSource.books.length,
            itemBuilder: (context, idx) {
              return Dismissible(
                key: UniqueKey(),
                confirmDismiss: (DismissDirection direction) async {
                  return true;
                },
                onDismissed: (direction) {
                  collectionDetailProvider.dataSource.books.removeAt(idx);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Yay! A SnackBar!')));
                },
                child: BookItem(
                    book: collectionDetailProvider.dataSource.books[idx],
                    onLongPress: () {
                      HapticFeedback.vibrate();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BookInfoBottomSheet(
                              bookEntity: collectionDetailProvider
                                  .dataSource.books[idx],
                            );
                          });
                    }),
              );
            },
          ),
        );
      }),
    );
  }
}
