import 'package:flutter/material.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/pages/search/components/tag_item.dart';
import 'package:youcomic/pages/search/provider.dart';
class SearchTags extends StatelessWidget {
  final SearchProvider provider;
  SearchTags({this.provider});
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel) {
        provider.onLoadMoreTag();
      } else {}
    });
    var items =
    provider.tagsDataSource.tags.map((TagEntity tag) => TagItem(tag:tag)).toList();
    print(provider.tagsDataSource.tags);
    return ListView(
      children: items,
      controller: _controller,
    );
  }
}
