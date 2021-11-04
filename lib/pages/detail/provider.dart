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
  bool hasBook = false;
}

class DetailProvider with ChangeNotifier {
  int? id;
  BookEntity book;
  var name = "未知";
  var bookLoad = "None";
  var artist = "未知";
  var series = "";
  var theme = "";
  List<TagEntity> tags = [];
  String? cover;
  var isSelectCollectionShow = false;
  CollectionDataSource collectionDataProvider = new CollectionDataSource();
  BookDataSource relateArtistBookDataSource = new BookDataSource();
  BookDataSource relateSeriesBookDataSource = new BookDataSource();
  BookDataSource relateThemeBookDataSource = new BookDataSource();
  List<CollectionItem> collectionItems = [];

  DetailProvider({required this.book}) {
    this.id = book.id;
  }

  loadRelateTag(int id) async {
    var response = await ApiClient().fetchBookTags(id);
    this.tags = TagEntity.parseList(response.data["result"]);
    book.tags = this.tags;
    notifyListeners();
  }

  switchSelectCollection() {
    isSelectCollectionShow = !isSelectCollectionShow;
    notifyListeners();
  }

  loadRelateArtist() async {
    print("load artist");
    print(book.tags.lastIndexWhere((tag) => tag.type == "artist"));
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
    var id = this.book.id;
    if (id == null) {
      return;
    }
    if (bookLoad != "None") {
      return;
    }
    this.bookLoad = "Loading";
    var response = await ApiClient().fetchBook(id, withHistory: true);
    this.book = response;
    name = this.book.name;

    // get cover
    cover = book.getBookCover();

    //get artist

    this.bookLoad = "Done";
    notifyListeners();
    await loadRelateTag(id);
    this.artist =
        getBookTagName(bookEntity: book, tagType: "artist", defaultText: "");

    //get series

    this.series =
        getBookTagName(bookEntity: book, tagType: "series", defaultText: "");
    ;

    //get theme

    this.theme =
        getBookTagName(bookEntity: book, tagType: "theme", defaultText: "");
    await loadRelateArtist();
    await loadRelateSeries();
    await loadRelateTheme();
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
    collectionDataProvider.collections =
        collectionDataProvider.collections.map((element) {
      if (element.id == collectionId) {
        element.contain = true;
      }
      return element;
    }).toList();
    notifyListeners();
  }

  removeFromCollection(int collectionId) async {
    var id = book.id;
    if (id == null) {
      return;
    }
    await ApiClient().removeBookFromCollection(collectionId, [
      id,
    ]);
    collectionDataProvider.collections =
        collectionDataProvider.collections.map((element) {
      if (element.id == collectionId) {
        element.contain = false;
      }
      return element;
    }).toList();
    notifyListeners();
  }
}
