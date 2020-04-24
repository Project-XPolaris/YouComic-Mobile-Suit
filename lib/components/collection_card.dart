import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/pages/collection/collection.dart';

class CollectionCard extends StatelessWidget {
  final CollectionEntity collectionEntity;

  CollectionCard({this.collectionEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Card(
        child: GestureDetector(
          onTap: (){
            CollectionDetailPage.launch(context, collectionEntity);
          },
            child: Column(
          children: <Widget>[
            Container(
              height: 70,
              child: Center(
                child: CircleAvatar(
                  child: Icon(Icons.folder),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Center(
                child: Text(
                  collectionEntity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
