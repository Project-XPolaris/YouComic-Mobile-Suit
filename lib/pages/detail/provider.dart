import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/datasource/collections.dart';
import 'package:youcomic/util/book.dart';

class CollectionItem extends CollectionEntity {
  bool hasBook;
}

class DetailProvider with ChangeNotifier {
  int id;
  BookEntity book;
  var name = "未知";
  var bookLoad = "None";
  var artist = "未知";
  var series = "";
  var theme = "";
  List<TagEntity> tags = [];
  var cover = "";
  var isSelectCollectionShow = false;
  CollectionDataSource collectionDataProvider = new CollectionDataSource();
  BookDataSource relateArtistBookDataSource = new BookDataSource();
  BookDataSource relateSeriesBookDataSource = new BookDataSource();
  BookDataSource relateThemeBookDataSource = new BookDataSource();
  List<CollectionItem> collectionItems = [];

  DetailProvider({BookEntity book}) {
    this.book = book;
  }

  loadRelateTag(int id) async {
    var response = await ApiClient().fetchBookTags(id);
    this.tags = TagEntity.parseList(response.data["result"]);
    notifyListeners();
  }

  switchSelectCollection() {
    isSelectCollectionShow = !isSelectCollectionShow;
    notifyListeners();
  }

  loadRelateArtist() async {
    if (book.tags.lastIndexWhere((tag) => tag.type == "artist") != -1) {
      var artistTag = book.tags.firstWhere((tag) => tag.type == "artist");
      relateArtistBookDataSource.extraQueryParam = {"tag": artistTag.id};
      await relateArtistBookDataSource.loadBooks(true);
      relateArtistBookDataSource.books
          .removeWhere((book) => book.id == this.book.id);
      notifyListeners();
    }
  }

  loadRelateSeries() async {
    if (book.tags.lastIndexWhere((tag) => tag.type == "series") != -1) {
      var seriesTag = book.tags.firstWhere((tag) => tag.type == "series");
      relateSeriesBookDataSource.extraQueryParam = {"tag": seriesTag.id};
      await relateSeriesBookDataSource.loadBooks(true);
      relateSeriesBookDataSource.books
          .removeWhere((book) => book.id == this.book.id);
      notifyListeners();
    }
  }

  loadRelateTheme() async {
    if (book.tags.lastIndexWhere((tag) => tag.type == "theme") != -1) {
      var theme = book.tags.firstWhere((tag) => tag.type == "theme");
      relateThemeBookDataSource.extraQueryParam = {"tag": theme.id};
      await relateThemeBookDataSource.loadBooks(true);
      relateThemeBookDataSource.books
          .removeWhere((book) => book.id == this.book.id);
      notifyListeners();
    }
  }

  onLoad() async {
    if (bookLoad != "None") {
      return;
    }
    this.bookLoad = "Loading";
    await ApiClient().fetchBook(this.book.id, withHistory: true);
    name = this.book.name;

    // get cover
    cover = book.cover;

    //get artist

    this.artist =
        getBookTagName(bookEntity: book, tagType: "artist", defaultText: "");

    //get series

    this.series =
        getBookTagName(bookEntity: book, tagType: "series", defaultText: "");
    ;

    //get theme

    this.theme =
        getBookTagName(bookEntity: book, tagType: "theme", defaultText: "");

    this.bookLoad = "Done";
    notifyListeners();
    if (this.book != null) {
      await loadRelateTag(this.book.id);
      await loadRelateArtist();
      await loadRelateSeries();
      await loadRelateTheme();
    }
  }

  loadCollections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    collectionDataProvider.extraQueryParam = {
      "owner": prefs.getInt("uid"),
      "pageSize": 10,
      "withBookContain": book.id
    };
    await collectionDataProvider.loadCollections(true);
    notifyListeners();
  }

  loadMoreCollections() async {
    collectionDataProvider.loadMore();
    notifyListeners();
  }

  addToCollection(collectionId) async {
    await ApiClient().addBookToCollection(collectionId, [
      this.book.id,
    ]);
    collectionDataProvider.collections = collectionDataProvider.collections.map((element) {
      if (element.id == collectionId) {
        element.contain = true;
      }
      return element;
    }).toList();
    notifyListeners();
  }

  removeFromCollection(int collectionId) async {
    await ApiClient().removeBookFromCollection(collectionId, [
      book.id,
    ]);
    collectionDataProvider.collections = collectionDataProvider.collections.map((element) {
      if (element.id == collectionId) {
        element.contain = false;
      }
      return element;
    }).toList();
    notifyListeners();
  }
}
