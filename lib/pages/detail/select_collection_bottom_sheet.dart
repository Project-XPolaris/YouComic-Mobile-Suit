import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/detail/components/collection_item.dart';
import 'package:youcomic/pages/detail/provider.dart';

class SelectCollectionBottomSheet extends StatelessWidget {
  final DetailProvider detailProvider;
  SelectCollectionBottomSheet({this.detailProvider});
  @override
  Widget build(BuildContext context) {
    buildCollectionItem(collection) {
      onItemClick() {
        detailProvider.addToCollection(collection.id);
        Navigator.pop(context);
      }

      return CollectionItem(collection, onItemClick);
    }

    var items = detailProvider.collectionDataProvider.collections
        .map((collection) => buildCollectionItem(collection));
    ScrollController _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel) {
        detailProvider.loadMoreCollections();
      } else {}
    });
    return Container(
        height: 400,
        child: Card(
          elevation: 100,
          child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("选择收藏夹"),
                  ),
                  Expanded(
                    child: ListView(
                      controller: _controller,
                      children: <Widget>[...items],
                    ),
                  ),
                ],
              )),
        ));
  }
}
