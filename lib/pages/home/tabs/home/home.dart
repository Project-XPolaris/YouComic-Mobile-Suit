import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/book_horizon_collection.dart';
import 'package:youcomic/components/collection_horizon_collection.dart';
import 'package:youcomic/pages/home/tabs/home/provider.dart';
import 'package:youcomic/pages/tag/tag.dart';
import 'package:youcomic/util/icon.dart';

import '../../../../menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(builder: (context, homeProvider, builder) {
        homeProvider.onLoad(false);
        renderRandomTags() {
          if (homeProvider.tagDataSource.tags.isEmpty) {
            return [Container()];
          }
          return [
            Container(
                child: Text("Random Tags",style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),),
              margin: EdgeInsets.only(top: 24,left: 16,bottom: 8)
            ),
            Container(
              margin: EdgeInsets.only(left: 16),
              child: Wrap(
              children: [
                ...homeProvider.tagDataSource.tags.map((e) => Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ActionChip(
                        avatar: Icon(selectIconByTagType(e.type)),
                        label: Text(e.name ?? ""),
                        onPressed: () {
                         TagPage.launch(context, e);
                        }

                      ),
                    ))
              ],
          ),
            )
          ];
        }
        return Scaffold(
          appBar: renderAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              await homeProvider.onLoad(true);
            },
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 16),
                  child: BookHorizonCollection(books: homeProvider.recentlyBookDataSource.books,title: "最近添加",),
                ),
                homeProvider.collectionDataSource.collections.isEmpty?Container():
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 16),
                  child: CollectionHorizonCollection(
                    collections: homeProvider.collectionDataSource.collections,
                  ),
                ),
                ...renderRandomTags(),
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 16),
                  child: BookHorizonCollection(books: homeProvider.randomBookDataSource.books,title: "Random Books",),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
