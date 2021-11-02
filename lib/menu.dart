import 'package:flutter/material.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/search/search.dart';
import 'package:youcomic/providers/layout.dart';

renderAppBar(LayoutProvider layoutProvider, BuildContext context) {
  var searchTitle = TextField(
    onSubmitted: (searchKey) {
      SearchPage.launch(context, searchKey);
      layoutProvider.switchSearch();
    },
    style: TextStyle(color: Colors.black54),
    decoration: InputDecoration(
      icon: Icon(
        Icons.search,
        color: Colors.black54,
      ),
      hintText: "search for ...",
      hintStyle: TextStyle(color: Colors.black26),
      border: InputBorder.none,
    ),
    cursorColor: Colors.black54,
  );

  List<Widget> actions = [];
  return AppBar(
    elevation: 1,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: layoutProvider.isSearching
        ? searchTitle
        : Text(
            "YouComic",
            style: TextStyle(color: Colors.black87),
          ),
    actions: <Widget>[
      IconButton(
        onPressed: layoutProvider.switchSearch,
        icon: Icon(
          layoutProvider.isSearching ? Icons.cancel : Icons.search,
          color: Colors.black54,
        ),
        color: Colors.black54,
      ),
    ]..addAll(actions),
  );
}
