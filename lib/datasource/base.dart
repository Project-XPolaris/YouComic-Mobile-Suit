abstract class DataSource<T> {
  List<T> data = [];
  bool hasMore = true;
  int page = 1;
  int pageSize = 5;
  bool isLoading = false;
  Map<String, dynamic> extraQueryParam = {};

  dynamic queryData(Map<String, dynamic> query);

  T convert(json);

  loadMore() async {
    if (!hasMore || isLoading) {
      return;
    }
    isLoading = true;
    var response = await queryData({"page_size": pageSize, "page": page + 1});
    List<T> more = List<T>.from(response.data["result"].map((json){
      return convert(json);
    }));    String nextUrl = response.data["next"];
    hasMore = nextUrl.isNotEmpty;
    page = response.data["page"];
    data.addAll(more);
    isLoading = false;
  }

  loadData(bool force) async {
    if ((data.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      var response = await queryData({"page_size": pageSize, "page": page});
      List<T> entities = List<T>.from(response.data["result"].map((json){
        return convert(json);
      }));
      this.data = entities;
      String nextUrl = response.data["next"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
    }
  }
}
