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
    dio.interceptors.add(CustomInterceptors());
  }

  static ApiClient _client() {
    if (_instance == null) {
      _instance = ApiClient._();
    }
    return _instance;
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
        options: RequestOptions(
            queryParameters: param, headers: {"Authorization": token}));
  }

  fetchTags(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/tags",
        options: RequestOptions(
            queryParameters: param, headers: {"Authorization": token}));
  }

  updateCollection(int collectionId, String name) async {
    return dio.patch("$baseUrl/collection/$collectionId",
        options: RequestOptions(
            data: {"name": name}, headers: {"Authorization": token}));
  }

  fetchCollections(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/collections",
        options: RequestOptions(
            queryParameters: param, headers: {"Authorization": token}));
  }

  addBookToCollection(collectionId, books) async {
    return dio.put("$baseUrl/collection/$collectionId/books",
        data: {"books": books},
        options: RequestOptions(headers: {"Authorization": token}));
  }

  createCollection(name) async {
    return dio.post("$baseUrl/collections",
        data: {"name": name},
        options: RequestOptions(headers: {"Authorization": token}));
  }

  deleteCollection(int collectionId) async {
    return dio.delete("$baseUrl/collection/$collectionId",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  fetchBook(int bookId, {withHistory}) async {
    var queryParams = new Map<String, dynamic>();
    if (withHistory) {
      queryParams["history"] = "True";
    }
    return dio.get(baseUrl + "/book/$bookId",
        options: RequestOptions(
            headers: {"Authorization": token}, queryParameters: queryParams));
  }

  fetchBookTags(int bookId) async {
    return dio.get(baseUrl + "/book/$bookId/tags",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  fetchPages(Map<String, dynamic> param) async {
    return dio.get(baseUrl + "/pages",
        options: RequestOptions(
            queryParameters: param, headers: {"Authorization": token}));
  }

  setToken(String sign) {
    this.token = sign;
  }

  subscribeTag(int tagId) async {
    return dio.put("$baseUrl/tag/$tagId/subscription",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  cancelSubscribeTag(int tagId) async {
    return dio.delete("$baseUrl/tag/$tagId/subscription",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  fetchHistories(Map<String, dynamic> param) async {
    return dio.get("$baseUrl/histories",
        options: RequestOptions(
            queryParameters: param, headers: {"Authorization": token}));
  }

  deleteHistory(int historyId) async {
    return dio.delete("$baseUrl/history/$historyId",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  clearHistory(int historyId) async {
    return dio.delete("$baseUrl/account/histories",
        options: RequestOptions(headers: {"Authorization": token}));
  }

  removeBookFromCollection(int collectionId, List<int> bookIds) async {
    return dio.delete("$baseUrl/collection/$collectionId/books",
        data: {"books": bookIds},
        options: RequestOptions(headers: {"Authorization": token}));
  }
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}
