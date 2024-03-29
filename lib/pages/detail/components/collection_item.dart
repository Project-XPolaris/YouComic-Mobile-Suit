import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';

class CollectionItem extends StatelessWidget {
  final CollectionEntity collection;
  final Function onItemSelect;

  CollectionItem(this.collection, this.onItemSelect);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemSelect();
      },
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
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
              Padding(
                  padding: EdgeInsets.only(),
                  child: Container(
                    width: 300,
                    child: Text(
                      collection.getName(),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  )),
            ],
          ),
        ),
        Divider(
          height: 0,
        )
      ]),
    );
  }
}
