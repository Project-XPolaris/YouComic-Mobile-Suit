import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/static.dart';

initApp(BuildContext context) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  bool isWideDevice = MediaQuery.of(context).size.width > 600;

  final String? homeBooksView =
      sharedPreferences.getString(HomeBooksViewStoreKey);
  if (homeBooksView != null) {
    ApplicationConfig().HomeBooksView = homeBooksView;
  } else {
    ApplicationConfig().updateHomeBooksView(isWideDevice ? "Grid" : "List");
  }

  final String? tagBooksView =
      sharedPreferences.getString(TagBooksViewStoreKey);
  if (tagBooksView != null) {
    ApplicationConfig().TagBooksView = tagBooksView;
  } else {
    ApplicationConfig().updateTagBooksView(isWideDevice ? "Grid" : "List");
  }
}
