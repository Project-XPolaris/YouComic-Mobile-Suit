import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/home/tabs/tag/subscribe.dart';
import 'package:youcomic/pages/tag/tag.dart';

class SubscribePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubscribeProvider>(
      create: (_) => SubscribeProvider(),
      child: Consumer<SubscribeProvider>(
          builder: (rootContext, provider, builder) {
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


        _onDismiss(direction) {}
        Future<bool> _onDismissConfirm(direction) async {
          bool willDelete = await showDialog(
              context: rootContext,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("确认操作"),
                  content: Text("将会取消订阅"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消订阅"),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    FlatButton(
                      child: Text("返回"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    )
                  ],
                );
              });
          return willDelete;
        }
        renderListView(){
          if (provider.dataSource.tags.isEmpty){
            return EmptyView(
              isLoading: provider.dataSource.isLoading,
              icon: Icon(
                Icons.bookmark,
                size: 96,
                color: Colors.black26,
              ),
              text: "暂时没有订阅的标签",
              onRefresh: (){
                provider.onForceReload();
              },
            );
          }else{
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: provider.dataSource.tags.length,
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemBuilder: (itemContext, idx) {
                final TagEntity tag = provider.dataSource.tags[idx];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: _onDismiss,
                  confirmDismiss: _onDismissConfirm,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.bookmark),
                    ),
                    onTap: (){
                      TagPage.launch(context, tag);
                    },
                    title: Text(tag.name),
                    subtitle: Text(tag.type),
                  ),
                );
              },
            );
          }
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: renderListView(),
          ),
        );
      }),
    );
  }
}
