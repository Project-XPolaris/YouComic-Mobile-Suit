import 'package:sqflite/sqflite.dart';
import 'package:youcomic/datasource/database/instance.dart';

class AccountEntity {
  final String apiUrl;
  final String username;
  final String password;
  final String type;

  AccountEntity({required this.apiUrl,required this.username, required this.password, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'apiUrl': apiUrl,
      'username': username,
      'password': password,
      'type': type,
    };
  }

  static Future save(AccountEntity entity) async {
    final Database database = await GetDatabase();
    await database.insert("accounts", entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future add(AccountEntity entity) async {
    final Database database = await GetDatabase();
    var result = await database.query("accounts",
        where: "username = ? and apiUrl = ? and type = ?",
        whereArgs: [entity.username, entity.apiUrl, entity.type]);
    if (result.isEmpty) {
      AccountEntity.save(entity);
    }
  }

  static Future saveAll(List<AccountEntity> entities) async {
    final Database database = await GetDatabase();
    Batch bt = database.batch();
    entities.forEach((element) {
      bt.insert("accounts", element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await bt.commit();
  }

  static Future<List<AccountEntity>> getAccountList() async {
    final Database db = await GetDatabase();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(
        maps.length,
        (index) => AccountEntity(
              username: maps[index]["username"],
              password: maps[index]["password"],
              apiUrl: maps[index]["apiUrl"],
              type: maps[index]["type"],
            ));
  }
}
