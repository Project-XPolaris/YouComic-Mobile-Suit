import 'package:flutter/material.dart';
import 'package:youcomic/pages/search/components/collection_item.dart';

import '../provider.dart';

class SearchCollections extends StatelessWidget {
  final SearchProvider provider;
  SearchCollections({required this.provider});
  @override
  Widget build(BuildContext context) {
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
  }
}
