import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/components/collection_item.dart';
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
            child: ListView.builder(
              itemCount: provider.dataSource.collections.length,
              controller: _controller,
              itemBuilder: (itemContext, idx) {
                final CollectionEntity collection =
                provider.dataSource.collections[idx];
                return Dismissible(
                  key: UniqueKey(),
                  child: CollectionItem(
                    collection: collection,
                    onRename: () {
                      showModalBottomSheet(
                          context: itemContext,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return TextInputBottomSheet(
                              initValue: collection.name,
                              buttonText: "重命名",
                              onOk: (String text) {
                                provider.updateCollection(collection.id, text);
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                  ),
                  onDismissed: (DismissDirection direction) {
                    provider.deleteCollection(collection.id);
                    Scaffold.of(itemContext).showSnackBar(new SnackBar(content: Text("已删除")));
                  },
                  confirmDismiss: (DismissDirection direction) async {
                    return showDeleteConfirm();
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
