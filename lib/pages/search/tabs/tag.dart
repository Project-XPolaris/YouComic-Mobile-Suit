import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/search/components/tag_item.dart';
import 'package:youcomic/providers/search.dart';

class SearchTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, provider, builder) {
      ScrollController _controller = new ScrollController();
      _controller.addListener(() {
        var maxScroll = _controller.position.maxScrollExtent;
        var pixel = _controller.position.pixels;
        if (maxScroll == pixel) {
          provider.onLoadMoreTag();
        } else {}
      });
      var items =
          provider.tagsDataSource.tags.map((tag) => TagItem(tag)).toList();
      print(provider.tagsDataSource.tags);
      return ListView(
        children: items,
        controller: _controller,
      );
    });
  }
}
