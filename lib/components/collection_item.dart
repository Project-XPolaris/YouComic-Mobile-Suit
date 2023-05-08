import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/pages/collection/collection.dart';
import 'package:youcomic/util/icon.dart';

class CollectionItem extends StatelessWidget {
  final CollectionEntity collection;
  final Function() onRename;
  CollectionItem({required this.collection,required this.onRename});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: (){
          CollectionDetailPage.launch(context, collection);
        },
        child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.folder_rounded,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          collection.getName(),
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onSelected: (value){
                    if (value == "rename"){
                      onRename();
                    }
                  },
                  itemBuilder: (BuildContext context){
                    return [
                      PopupMenuItem(
                        value: "rename",
                        child: Text('重命名'),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text('删除'),
                      )
                    ];
                  },
                )
              ],
            )),
      ),
      Divider()
    ]);
  }
}
