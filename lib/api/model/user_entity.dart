import 'package:youcomic/generated/json/base/json_convert_content.dart';

class UserEntity with JsonConvert<UserEntity> {
	int id;
	String nickname;
	String avatar;
}
