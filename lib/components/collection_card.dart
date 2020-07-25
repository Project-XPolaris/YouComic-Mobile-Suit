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
        child: InkWell(
          onTap: (){
            CollectionDetailPage.launch(context, collectionEntity);
          },
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.only(top: 16,bottom: 16),
                  child: Center(
                    child: Icon(Icons.folder,size: 36,color: Colors.white,),
                  ),
                ),
              )
              ,
              Divider(height: 1,),
              Padding(
                padding: EdgeInsets.only(top: 8),
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
          ),
        )
      ),
    );
  }
}
