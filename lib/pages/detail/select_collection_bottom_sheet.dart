import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/pages/detail/provider.dart';

class SelectCollectionBottomSheet extends StatelessWidget {
  SelectCollectionBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, builder) {
        _itemBuilder(itemContext, idx) {
          CollectionEntity entity =
              detailProvider.collectionDataProvider.collections[idx];
          onItemClick() async {
            var id = entity.id;
            if (id == null) {
              return;
            }
            if (entity.contain) {
              detailProvider.removeFromCollection(id);
            } else {
              detailProvider.addToCollection(entity.id);
            }
          }

          return ListTile(
            title: Text(entity.getName()),
            leading: CircleAvatar(
              child: Icon(Icons.folder_rounded),
            ),
            onTap: onItemClick,
            trailing: entity.contain ? Text("已存在") : null,
          );
        }

        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            detailProvider.collectionDataProvider.loadMore();
          } else {}
        });
        return Container(
            height: 800,
            child: Card(
              elevation: 100,
              child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("选择收藏夹"),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          itemCount: detailProvider
                              .collectionDataProvider.collections.length,
                          controller: _controller,
                          itemBuilder: _itemBuilder,
                        ),
                      ),
                    ],
                  )),
            ));
      },
    );
  }
}
