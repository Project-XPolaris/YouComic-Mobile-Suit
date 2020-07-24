import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/components/collection_item.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/components/text_input_bottom_sheet.dart';
import 'package:youcomic/home/tabs/favourite/collection.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CollectionProvider>(
      create: (_) => CollectionProvider(),
      child: Consumer<CollectionProvider>(builder: (rootContext, provider, builder) {
        provider.onLoad();
        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            provider.onLoadMoreCollection();
          }
        });
        Future _pullToRefresh() async {
          await provider.onForceReload();
        }
        Future<bool> showDeleteConfirm() async {
          bool willDelete = await showDialog(
              context: rootContext,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("确认删除"),
                  content: Text("将会移除收藏夹"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("删除"),
                      onPressed: () {
                        Navigator.pop(context,true);
                      },
                    ),
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.pop(context,false);
                      },
                    )
                  ],
                );
              });
          return willDelete;
        }
        Widget renderList(){
          return EmptyView(
            text: "这里暂时没有东西",
            isLoading: provider.dataSource.isLoading,
            icon: Icon(
              Icons.star,
              size: 96,
              color: Colors.black26,
            ),
            onRefresh: (){
              provider.onForceReload();
            },
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: rootContext,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return TextInputBottomSheet(
                      initValue: "",
                      buttonText: "创建",
                      onOk: (String text) {
                        provider.createCollection(text);
                        Navigator.pop(context);
                      },
                    );
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: renderList(),
          ),
        );
      }),
    );
  }
}
