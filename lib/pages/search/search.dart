import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/search/provider.dart';
import 'package:youcomic/pages/search/tabs/books.dart';
import 'package:youcomic/pages/search/tabs/collection.dart';
import 'package:youcomic/pages/search/tabs/tag.dart';

class SearchPage extends StatelessWidget {
  final String searchKey;
  SearchPage({this.searchKey});

  static launch(BuildContext context, String searchKey) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(searchKey: searchKey,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(searchKey:searchKey),
      child: Consumer<SearchProvider>(builder: (context, provider, builder) {
        provider.onLoad();
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text(
                provider.title,
                style: TextStyle(color: Colors.black87),
              ),
              bottom: TabBar(
                indicatorColor: Colors.black87,
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black87,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.book,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.bookmark,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.folder,
                  )),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SearchBooksTab(provider: provider,),
                SearchTags(provider: provider,),
                SearchCollections(provider: provider,),
              ],
            ),
          ),
        );
      }),
    );
  }
}
