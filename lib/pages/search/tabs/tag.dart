import 'package:flutter/material.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/pages/search/components/tag_item.dart';
import 'package:youcomic/pages/search/provider.dart';
import 'package:youcomic/pages/tag/tag.dart';

class SearchTags extends StatelessWidget {
  final SearchProvider provider;

  SearchTags({required this.provider});

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
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (itemContext, idx) {
        TagEntity tag = provider.tagsDataSource.tags[idx];
        return TagItem(
          tag: tag,
          onTap: () {
            TagPage.launch(context, tag);
          },
        );
      },
      itemCount: provider.tagsDataSource.tags.length,
      controller: _controller,
    );
  }
}
