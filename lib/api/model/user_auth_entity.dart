
class UserAuthEntity {
	int? id;
	String? sign;
	UserAuthEntity.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		sign = json['sign'];
	}
}
