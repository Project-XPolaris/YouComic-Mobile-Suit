import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MdServiceHistory {
  final String mdUrl;
  final String name;
  final String prefix;
  final String? mdToken;

  MdServiceHistory({
    required this.mdUrl,
    required this.name,
    required this.prefix,
    this.mdToken,
  });

  factory MdServiceHistory.fromJson(Map<String, dynamic> json) {
    return MdServiceHistory(
      mdUrl: json['mdUrl'] ?? '',
      name: json['name'] ?? '',
      prefix: json['prefix'] ?? '',
      mdToken: json['mdToken'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mdUrl': mdUrl,
        'name': name,
        'prefix': prefix,
        if (mdToken != null) 'mdToken': mdToken,
      };
}

class MdServiceHistoryManager {
  static final MdServiceHistoryManager _singleton =
      MdServiceHistoryManager._internal();
  List<MdServiceHistory> list = [];

  factory MdServiceHistoryManager() {
    return _singleton;
  }

  MdServiceHistoryManager._internal();

  static const String _storeKey = 'mdServiceHistory';

  Future<void> refreshHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storeKey);
    if (raw == null || raw.isEmpty) {
      list = [];
      return;
    }
    final List<dynamic> rawList = json.decode(raw);
    list = rawList.map((e) => MdServiceHistory.fromJson(e)).toList();
  }

  Future<void> add(MdServiceHistory history) async {
    list.removeWhere((element) =>
        element.mdUrl == history.mdUrl && element.prefix == history.prefix);
    list.insert(0, history);
    await save();
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_storeKey, raw);
  }
}
