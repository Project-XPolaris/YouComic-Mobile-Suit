import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/static.dart';

class ApplicationConfig {
  var useNanoMode = false;
  String? uid;
  String HomeBooksView = "List";
  String TagBooksView = "List";
  static final ApplicationConfig _singleton = ApplicationConfig._internal();

  factory ApplicationConfig() {
    return _singleton;
  }

  updateHomeBooksView(String value) async {
    HomeBooksView = value;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(HomeBooksViewStoreKey, value);
  }

  updateTagBooksView(String value) async {
    TagBooksView = value;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(TagBooksViewStoreKey, value);
  }

  ApplicationConfig._internal();
}
