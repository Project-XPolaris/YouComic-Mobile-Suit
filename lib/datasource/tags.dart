import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/util.dart';

class TagDataSource {
  var tags = [];
  var hasMore = true;
  int page = 1;
  int pageSize = 10;
  var isLoading = false;
  Map<String, dynamic> extraQueryParam;

  loadMore() async {
    if (!hasMore || isLoading) {
      return;
    }
    isLoading = true;
    var response = await ApiClient().fetchTags({
      "order": "-id",
      "page_size": pageSize,
      "page": page + 1
    }..addAll(extraQueryParam));
    var moreBooks = response.data["result"];
    String nextUrl = response.data["next"];
    hasMore = nextUrl.isNotEmpty;
    page = response.data["page"];
    tags.addAll(moreBooks);
    isLoading = false;
  }

  loadTags(bool force) async {
    if ((tags.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      var response = await ApiClient().fetchBooks({
        "order": "-id",
        "page_size": pageSize,
        "page": page
      }..addAll(extraQueryParam));
      tags = response.data["result"];

      String nextUrl = response.data["next"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
      print("------------------------------");
    }
  }
}
