import 'dart:convert';

import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/api/util.dart';

class CollectionDataSource {
  List<CollectionEntity> collections = [];

  bool hasMore = true;
  int page = 1;
  int pageSize = 10;
  bool isLoading = false;
  Map<String, dynamic> extraQueryParam = {};

  loadMore() async {
    if (!hasMore || isLoading) {
      return;
    }
    isLoading = true;
    final response = await ApiClient().fetchCollections({
      "order": "-id",
      "page_size": pageSize,
      "page": page + 1
    }..addAll(extraQueryParam));
    final moreCollection = CollectionEntity.parseList(response.data["result"]);
    String nextUrl = response.data["next"];
    hasMore = nextUrl.isNotEmpty;
    page = response.data["page"];
    collections.addAll(moreCollection);
    isLoading = false;
  }

  loadCollections(bool force) async {
    if ((collections.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      var response = await ApiClient().fetchCollections({
        "order": "-id",
        "page_size": pageSize,
        "page": page
      }..addAll(extraQueryParam));
      collections = CollectionEntity.parseList(response.data["result"]);
      String nextUrl = response.data["next"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
    }
  }
}
