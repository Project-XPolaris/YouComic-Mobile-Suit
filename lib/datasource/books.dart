import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/util.dart';

class BookDataSource {
  List<BookEntity> books = [];
  bool hasMore = true;
  int page = 1;
  int pageSize = 5;
  bool isLoading = false;
  Map<String, dynamic> extraQueryParam = {};
  loadMore() async {
    if (!hasMore || isLoading) {
      return;
    }
    isLoading = true;
    var response = await ApiClient().fetchBooks({
      "order": "-id",
      "page_size": pageSize,
      "page": page + 1
    }..addAll(extraQueryParam));
    List<BookEntity> moreBooks = BookEntity.parseList(response.data["result"]);
    moreBooks.forEach((book) => book.cover = getRealThumbnailCover(book.id,book.cover));
    String nextUrl = response.data["next"];
    hasMore = nextUrl.isNotEmpty;
    page = response.data["page"];
    books.addAll(moreBooks);
    isLoading = false;
  }

  loadBooks(bool force) async {
    if ((books.isEmpty && !isLoading) || force) {
      page = 1;
      isLoading = true;
      var response = await ApiClient().fetchBooks({
        "order": "-id",
        "page_size": pageSize,
        "page": page
      }..addAll(extraQueryParam));
      books = BookEntity.parseList(response.data["result"]);
      books.forEach((book) => book.cover = getRealThumbnailCover(book.id,book.cover));
      String nextUrl = response.data["next"];
      hasMore = nextUrl.isNotEmpty;
      isLoading = false;
    }
  }
}
