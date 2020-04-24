import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/page.dart';

class PageDataSource {
  List<PageEntity> pages = [];

  bool hasMore = true;
  int page = 1;
  int pageSize = 5;
  bool isLoading = false;
  Map<String, dynamic> extraQueryParam;
  int count = 0;

  loadMore() async {
    if (!hasMore || isLoading) {
      return;
    }
    isLoading = true;
    final response = await ApiClient().fetchPages({
      "order": "order",
      "page_size": 5,
      "page": page + 1
    }..addAll(extraQueryParam));
    final morePages = PageEntity.parseList(response.data["result"]);
    morePages
        .forEach((page) => page.path = "${ApiClient().baseUrl}${page.path}");
    String nextUrl = response.data["next"];
    page = response.data["page"];
    hasMore = nextUrl.isNotEmpty;
    pages.addAll(morePages);
    isLoading = false;
  }

  loadPages(bool force) async {
    if ((pages.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      print({
        "order": "order",
        "page_size": 99999,
        "page": page
      }..addAll(extraQueryParam));
      var response = await ApiClient().fetchPages({
        "order": "order",
        "page_size": 99999,
        "page": page
      }..addAll(extraQueryParam));
      print(response.data);
      pages = PageEntity.parseList(response.data["result"]);
      pages.forEach((page) => page.path = "${ApiClient().baseUrl}${page.path}");
      String nextUrl = response.data["next"];
      count = response.data["count"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
    }
  }
}
