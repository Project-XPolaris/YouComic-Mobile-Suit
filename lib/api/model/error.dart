import 'package:dio/dio.dart';

class ApiResponse {
  String? reason;
  String? code;
  bool success = false;
  ApiResponse.fromDioError(DioError error){
    this.reason = error.response?.data["reason"];
    this.code = error.response?.data["code"];
    this.success = error.response?.data["success"];
  }
  ApiResponse.fromJSON(dynamic json){
    this.reason = json["reason"];
    this.code = json["code"];
    this.success = json["success"];
  }
}