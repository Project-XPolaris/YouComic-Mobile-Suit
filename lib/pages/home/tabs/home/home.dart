import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/book_horizon_collection.dart';
import 'package:youcomic/components/collection_horizon_collection.dart';
import 'package:youcomic/pages/home/tabs/home/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(builder: (context, homeProvider, builder) {
        homeProvider.onLoad(false);
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await homeProvider.onLoad(true);
            },
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 16),
                  child: BookHorizonCollection(books: homeProvider.recentlyBookDataSource.books),
                ),
                homeProvider.collectionDataSource.collections.isEmpty?Container():
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 16),
                  child: CollectionHorizonCollection(
                    collections: homeProvider.collectionDataSource.collections,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
