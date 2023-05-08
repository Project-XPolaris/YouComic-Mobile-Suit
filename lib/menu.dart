import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/search/search.dart';
import 'package:youcomic/providers/layout.dart';

renderAppBar( BuildContext context,{actions = const <Widget>[]}) {
  LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
  var searchTitle = TextField(
    onSubmitted: (searchKey) {
      SearchPage.launch(context, searchKey);
      layoutProvider.switchSearch();
    },
    style: TextStyle(),
    decoration: InputDecoration(
      icon: Icon(
        Icons.search_rounded,
      ),
      hintText: "search for ...",
      hintStyle: TextStyle(),
      border: InputBorder.none,
    ),
  );
  return AppBar(
    automaticallyImplyLeading: false,
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: layoutProvider.isSearching
        ? searchTitle
        : Text(
            "YouComic",
          ),
    actions: <Widget>[
      IconButton(
        onPressed: layoutProvider.switchSearch,
        icon: Icon(
          layoutProvider.isSearching ? Icons.cancel_rounded : Icons.search_rounded,
        ),
      ),
    ]..addAll(actions),
  );
}
