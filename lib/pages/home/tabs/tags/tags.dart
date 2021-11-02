import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/pages/home/tabs/tags/provider.dart';
import 'package:youcomic/pages/tag/tag.dart';
import 'package:youcomic/util/icon.dart';

class TagsPage extends StatelessWidget {
  final TagsProvider externalTagProvider;
  TagsPage({required this.externalTagProvider});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagsProvider>.value(
      value: externalTagProvider,
      child: Consumer<TagsProvider>(builder: (rootContext, provider, builder) {
        provider.onLoad();
        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            provider.onLoadMore();
          }
        });
        _pullToRefresh() async {
          await provider.onForceReload();
        }

        return Scaffold(
            body: RefreshIndicator(
              onRefresh: _pullToRefresh,
              child: ListView.separated(
                  controller: _controller,
                  itemBuilder: (itemContext, idx) {
                    final TagEntity tag = provider.dataSource.tags[idx];
                    return ListTile(
                        title: Text(tag.getName()),
                        subtitle: Text(tag.getType()),
                        leading: CircleAvatar(
                          child: Icon(selectIconByTagType(tag.getType())),

                        ),
                        onTap: () => TagPage.launch(context, tag));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: provider.dataSource.tags.length),
            ));
      }),
    );
  }
}
