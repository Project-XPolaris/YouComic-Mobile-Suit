import 'package:flutter/material.dart';
class FormProvider with ChangeNotifier {
  Map<String,dynamic> values = {};
  setValue(String key,dynamic value){
    this.values[key] = value;
  }
  dynamic getValue(String key){
    return values[key];
  }
  FormProvider(){
    this.values = new Map<String,dynamic>();
  }
}