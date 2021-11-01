class UserEntity  {
	int? id;
	String? nickname;
	String? avatar;

	UserEntity.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		nickname = json['nickname'];
		avatar = json['avatar'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['nickname'] = this.nickname;
		data['avatar'] = this.avatar;
		return data;
	}
}
