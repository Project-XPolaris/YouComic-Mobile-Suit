import 'package:youcomic/api/model/book_entity.dart';

class HistoryEntity {
  int id;
  int userId;
  int bookId;
  String createdAt;
  BookEntity book;

  HistoryEntity({this.id, this.userId, this.bookId, this.createdAt});

  HistoryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    createdAt = json['created_at'];
    if (json.containsKey("book")) {
      book = BookEntity.fromJson(json['book']);
    }
  }

  static List<HistoryEntity> parseList(List<dynamic> list) {
    return list.map((elm) => HistoryEntity.fromJson(elm)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['book_id'] = this.bookId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
