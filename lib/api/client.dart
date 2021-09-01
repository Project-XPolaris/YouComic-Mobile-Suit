import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  Dio dio = Dio();
  String token = "";
  String baseUrl = "";

  factory ApiClient() => _client();

  static ApiClient _instance;

  ApiClient._() {
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  static ApiClient _client() {
    if (_instance == null) {
      _instance = ApiClient._();
    }
    return _instance;
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
    var parseBaseUri = Uri.parse(baseUrl);
    var uri = Uri(
        host: parseBaseUri.host,
        port: parseBaseUri.port,
        scheme: parseBaseUri.scheme,
        queryParameters: encodeParam,
        path: path);
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
        options: Options(headers: {"Authorization": token}),
        queryParameters: param);
  }

  fetchTags(Map<String, dynamic> param) async {
    return dio.get(getRequestUri(param, "/tags"),
        options: Options(headers: {"Authorization": token}));
  }

  updateCollection(int collectionId, String name) async {
    return dio.patch(
      "$baseUrl/collection/$collectionId",
      options: Options(headers: {"Authorization": token}),
      data: {"name": name},
    );
  }

  fetchCollections(Map<String, dynamic> param) async {
    return dio.get(
      baseUrl + "/collections",
      options: Options(headers: {"Authorization": token}),
      queryParameters: param,
    );
  }

  addBookToCollection(collectionId, books) async {
    return dio.put(
      "$baseUrl/collection/$collectionId/books",
      options: Options(headers: {"Authorization": token}),
      data: {"books": books},
    );
  }

  createCollection(name) async {
    return dio.post("$baseUrl/collections",
        data: {"name": name},
        options: Options(headers: {"Authorization": token}));
  }

  deleteCollection(int collectionId) async {
    return dio.delete("$baseUrl/collection/$collectionId",
        options: Options(headers: {"Authorization": token}));
  }

  fetchBook(int bookId, {withHistory}) async {
    var queryParams = new Map<String, dynamic>();
    if (withHistory) {
      queryParams["history"] = "True";
    }
    return dio.get(baseUrl + "/book/$bookId",
        options: Options(
          headers: {"Authorization": token},
        ),
        queryParameters: queryParams);
  }

  fetchBookTags(int bookId) async {
    return dio.get(baseUrl + "/book/$bookId/tags",
        options: Options(headers: {"Authorization": token}));
  }

  fetchPages(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/pages",
        options: Options(
            headers: {"Authorization": token}),queryParameters: param, );
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
        options: Options(
           headers: {"Authorization": token}), queryParameters: param, );
  }

  deleteHistory(int historyId) async {
    return dio.delete("$baseUrl/history/$historyId",
        options: Options(headers: {"Authorization": token}));
  }

  clearHistory(int historyId) async {
    return dio.delete("$baseUrl/account/histories",
        options: Options(headers: {"Authorization": token}));
  }

  removeBookFromCollection(int collectionId, List<int> bookIds) async {
    return dio.delete("$baseUrl/collection/$collectionId/books",
        data: {"books": bookIds},
        options: Options(headers: {"Authorization": token}));
  }
}

