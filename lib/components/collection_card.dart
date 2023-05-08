import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/pages/collection/collection.dart';

class CollectionCard extends StatelessWidget {
  final CollectionEntity collectionEntity;

  CollectionCard({required this.collectionEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: GestureDetector(
          onTap: (){
            CollectionDetailPage.launch(context, collectionEntity);
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                  color: Theme.of(context).colorScheme.secondaryContainer
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 16,bottom: 16),
                  child: Center(
                    child: Icon(Icons.folder_rounded,size: 36,color: Theme.of(context).colorScheme.onSecondaryContainer,),
                  ),
                ),
              ),
              Divider(height: 1,),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    collectionEntity.getName(),
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
