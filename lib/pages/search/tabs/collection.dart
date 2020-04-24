import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/search/components/collection_item.dart';
import 'package:youcomic/providers/search.dart';

class SearchCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, provider, builder) {
      ScrollController _controller = new ScrollController();
      _controller.addListener(() {
        var maxScroll = _controller.position.maxScrollExtent;
        var pixel = _controller.position.pixels;
        if (maxScroll == pixel) {
          provider.onLoadMoreCollections();
        } else {}
      });
      var items =
      provider.collectionDataSource.collections.map((collection) => CollectionItem(collection)).toList();
      return ListView(
        children: items,
        controller: _controller,
      );
    });
  }
}
