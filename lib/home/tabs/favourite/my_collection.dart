import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/components/text_input_bottom_sheet.dart';
import 'package:youcomic/components/text_input_dialog.dart';
import 'package:youcomic/home/tabs/favourite/provider.dart';
import 'package:youcomic/pages/collection/collection.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CollectionProvider>(
      create: (_) => CollectionProvider(),
      child: Consumer<CollectionProvider>(
          builder: (rootContext, provider, builder) {
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
                        Navigator.pop(context, true);
                      },
                    ),
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    )
                  ],
                );
              });
          return willDelete;
        }

        Widget renderList() {
          if (provider.dataSource.collections.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                      height: 1,
                    ),
                itemCount: provider.dataSource.collections.length,
                controller: _controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (itemContext, idx) {
                  final CollectionEntity collection =
                      provider.dataSource.collections[idx];
                  return Dismissible(
                    key: UniqueKey(),
                    child: InkWell(
                      onTap: () {
                        CollectionDetailPage.launch(context, collection);
                      },
                      onLongPress: () {
                        var id = collection.id;
                        if (id != null) {
                          showModalBottomSheet(
                              context: itemContext,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return TextInputBottomSheet(
                                  initValue: collection.getName(),
                                  buttonText: "重命名",
                                  onOk: (String text) {
                                    provider.updateCollection(id, text);
                                    Navigator.pop(context);
                                  },
                                );
                              });
                        }
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.folder,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(collection.getName()),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) {
                      var id = collection.id;
                      if (id == null) {
                        return;
                      }
                      provider.deleteCollection(id);
                      Scaffold.of(itemContext).showSnackBar(new SnackBar(content: Text("已删除")));
                    },
                    confirmDismiss: (DismissDirection direction) async {
                      return showDeleteConfirm();
                    },
                  );
                });
          }
          return EmptyView(
            text: "这里暂时没有东西",
            isLoading: provider.dataSource.isLoading,
            icon: Icon(
              Icons.star,
              size: 96,
              color: Colors.black26,
            ),
            onRefresh: () {
              provider.onForceReload();
            },
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TextInputDialog(
                      title: "创建合集",
                      label: "名称",
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onOk: (text) {
                        if (text.length > 0) {
                          provider.createCollection(text);
                        }
                        Navigator.of(context).pop();
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
