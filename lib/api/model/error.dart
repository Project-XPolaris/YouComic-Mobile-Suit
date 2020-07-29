import 'package:dio/dio.dart';

class ApiError {
  String reason;
  String code;
  bool success;
  ApiError.fromDioError(DioError error){
    this.reason = error.response.data["reason"];
    this.code = error.response.data["code"];
    this.success = error.response.data["success"];
  }
}