import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/api/util.dart';

class TagDataSource {
  List<TagEntity> tags = [];
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
      "page": page + 1,
    }..addAll(extraQueryParam));
    var moreTags = TagEntity.parseList(response.data["result"]);
    String nextUrl = response.data["next"];
    hasMore = nextUrl.isNotEmpty;
    page = response.data["page"];
    tags.addAll(moreTags);
    isLoading = false;
  }

  loadTags(bool force) async {
    if ((tags.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      var response = await ApiClient().fetchTags({
        "order": "-id",
        "page_size": pageSize,
        "page": page,
      }..addAll(extraQueryParam));
      tags = TagEntity.parseList(response.data["result"]);

      String nextUrl = response.data["next"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
    }
  }
}
