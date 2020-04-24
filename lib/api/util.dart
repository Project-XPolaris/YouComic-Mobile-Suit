import 'package:youcomic/api/client.dart';

String getRealThumbnailCover(String path){
  return "${ApiClient().baseUrl}$path".replaceFirst("cover", "cover_thumbnail");
}