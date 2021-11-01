import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/components/collection_card.dart';

import 'horizon_card_collection.dart';

class CollectionHorizonCollection extends StatelessWidget {
  List<CollectionEntity> collections;

  CollectionHorizonCollection({required this.collections});
  @override
  Widget build(BuildContext context) {
    return HorizonCardCollection(
      title: "收藏夹",
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ...collections.map((collection) => CollectionCard(collectionEntity: collection,))
        ],
      ),
    );
  }
}