import 'package:youcomic/api/client.dart';
import 'package:path/path.dart' as p;

String? getRealThumbnailCover(int? bookId,String? coverPath){
  if (bookId == null || coverPath == null) {
    return null;
  }
  return "${ApiClient().baseUrl}/content/book/$bookId/cover_thumbnail${p.extension(coverPath)}";
}