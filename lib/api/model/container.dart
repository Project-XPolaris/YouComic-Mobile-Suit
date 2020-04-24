import 'package:youcomic/generated/json/base/json_convert_content.dart';

class ListContainer<T> with JsonConvert<ListContainer> {
  int count;
  String next;
  String prev;
  int page;
  int pageSize;
  List<T> result;
}
