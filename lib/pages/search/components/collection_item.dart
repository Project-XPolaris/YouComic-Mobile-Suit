import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/pages/collection/collection.dart';
import 'package:youcomic/util/icon.dart';

class CollectionItem extends StatelessWidget {
  final CollectionEntity collection;

  CollectionItem(this.collection);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        CollectionDetailPage.launch(context, collection);
      },
      child: Column(children: [

        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 16),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  child: Icon(
                    Icons.folder,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(),
                  child: Container(
                    width: 300,
                    child: Text(
                      collection.name,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  )),
            ],
          ),
        ),
        Divider(height: 0,)
      ]),
    );
  }
}
