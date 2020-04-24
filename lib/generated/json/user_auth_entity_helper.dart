import 'package:youcomic/api/model/user_auth_entity.dart';

userAuthEntityFromJson(UserAuthEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['sign'] != null) {
		data.sign = json['sign']?.toString();
	}
	return data;
}

Map<String, dynamic> userAuthEntityToJson(UserAuthEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['sign'] = entity.sign;
	return data;
}