import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/container.dart';
import 'package:youcomic/api/model/error.dart';
import 'package:youcomic/api/model/page.dart';

class ApiClient {
  Dio dio = Dio();
  String token = "";
  String baseUrl = "";

  factory ApiClient() => _client();

  static ApiClient? _instance;

  ApiClient._() {
    dio.options.connectTimeout = 50000; //5s
    dio.options.receiveTimeout = 30000;
  }

  static ApiClient _client() {
    if (_instance == null) {
      _instance = ApiClient._();
    }
    return _instance!;
  }

  String getRequestUri(Map<String, dynamic> queryParam, String path) {
    Map<String, dynamic> encodeParam = new Map();

    queryParam.forEach((key, value) {
      if (value is List) {
        encodeParam[key] = value.map((e) => e.toString());
      } else {
        encodeParam[key] = value.toString();
      }
    });
    var parseBaseUri = Uri.parse(baseUrl + path);
    var uri = Uri(
        host: parseBaseUri.host,
        port: parseBaseUri.port,
        scheme: parseBaseUri.scheme,
        queryParameters: encodeParam,
        path: parseBaseUri.path);
    return uri.toString();
  }

  authUser(String username, String password) async {
    return dio.post(
      baseUrl + "/user/auth",
      data: {"username": username, "password": password},
    );
  }

  fetchUser(int uid) async {
    return dio.get(baseUrl + "/user/$uid");
  }

  fetchBooks(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/books",
        queryParameters: param,
        options: Options(headers: {"Authorization": token}));
  }

  fetchTags(Map<String, dynamic> param) async {
    return dio.get(getRequestUri(param, "/tags"),
        options: Options(headers: {"Authorization": token}));
  }

  updateCollection(int collectionId, String name) async {
    return dio.patch("$baseUrl/collection/$collectionId",
        data: {"name": name},
        options: Options(headers: {"Authorization": token}));
  }

  fetchCollections(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/collections",
        queryParameters: param,
        options: Options(headers: {"Authorization": token}));
  }

  addBookToCollection(collectionId, books) async {
    return dio.put("$baseUrl/collection/$collectionId/books",
        data: {"books": books},
        options: Options(headers: {"Authorization": token}));
  }

  createCollection(name) async {
    return dio.post("$baseUrl/collections",
        data: {"name": name},
        options: Options(headers: {"Authorization": token}));
  }

  Future<ApiResponse> deleteCollection(int collectionId) async {
    Response response = await dio.delete("$baseUrl/collection/$collectionId",
        options: Options(headers: {"Authorization": token}));
    return ApiResponse.fromJSON(response.data);
  }

  Future<BookEntity> fetchBook(int bookId, {withHistory}) async {
    var queryParams = new Map<String, dynamic>();
    if (withHistory) {
      queryParams["history"] = "True";
    }
    Response response = await dio.get(baseUrl + "/book/$bookId",
        queryParameters: queryParams,
        options: Options(headers: {"Authorization": token}));
    return BookEntity.fromJson(response.data);
  }

  fetchBookTags(int bookId) async {
    return dio.get(baseUrl + "/book/$bookId/tags",
        options: Options(headers: {"Authorization": token}));
  }

  Future<ListContainer<PageEntity>> fetchPages(Map<String, dynamic> param) async {
    Response response =  await dio.get(baseUrl + "/pages",
        queryParameters: param,
        options: Options(headers: {"Authorization": token}));
    return ListContainer<PageEntity>.fromJSON(response.data, (json) => PageEntity.fromJson(json));
  }

  setToken(String sign) {
    this.token = sign;
  }

  subscribeTag(int tagId) async {
    return dio.put("$baseUrl/tag/$tagId/subscription",
        options: Options(headers: {"Authorization": token}));
  }

  cancelSubscribeTag(int tagId) async {
    return dio.delete("$baseUrl/tag/$tagId/subscription",
        options: Options(headers: {"Authorization": token}));
  }

  fetchHistories(Map<String, dynamic> param) async {
    return dio.get("$baseUrl/histories",
        queryParameters: param,
        options: Options(headers: {"Authorization": token}));
  }

  deleteHistory(int historyId) async {
    return dio.delete("$baseUrl/history/$historyId",
        options: Options(headers: {"Authorization": token}));
  }

  clearHistory(int historyId) async {
    return dio.delete("$baseUrl/my/histories",
        options: Options(headers: {"Authorization": token}));
  }

  removeBookFromCollection(int collectionId, List<int> bookIds) async {
    return dio.delete("$baseUrl/collection/$collectionId/books",
        data: {"books": bookIds},
        options: Options(headers: {"Authorization": token}));
  }

  createHistory({required int bookId,int pagePos = 0}){
    return dio.post("$baseUrl/histories",
        data: {"bookId": bookId,"pagePos":pagePos},
        options: Options(headers: {"Authorization": token}));
  }
}
