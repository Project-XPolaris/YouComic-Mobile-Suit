// Open the database and store the reference.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> GetDatabase() async {
  var database = await openDatabase(
    join(await getDatabasesPath(), 'youcomic_database.db'),
    onCreate: (db, version){
      return db.execute(
        "CREATE TABLE accounts(username TEXT, password TEXT, apiUrl Text, type Text)",
      );
    },
    version: 1
  );
  return database;
}
