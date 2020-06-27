import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/history.dart';
import 'package:youcomic/api/util.dart';
import 'package:youcomic/datasource/base.dart';

class HistoryDataSource extends DataSource<HistoryEntity> {
  @override
  HistoryEntity convert(json) {
    HistoryEntity entity = HistoryEntity.fromJson(json);
    if (entity.book != null) {
      entity.book.cover =
          getRealThumbnailCover(entity.book.id, entity.book.cover);
    }
    return entity;
  }

  @override
  queryData(Map<String, dynamic> query) async {
    return await ApiClient().fetchHistories(query
      ..addAll({"order": "updated_at desc", "withBook": "True"})
      ..addAll(extraQueryParam));
  }
}
