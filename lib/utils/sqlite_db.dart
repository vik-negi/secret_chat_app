import 'package:chatapp/models/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<bool> initializedDB(Database db) async {
    try {
      String path = await getDatabasesPath();
      db = await openDatabase(
        join(path, 'notes.db'),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY , text TEXT NOT NULL, title TEXT NOT NULL, dateTime TEXT NOT NULL,image BLOB , categories TEXT,  selected BOOLEAN NOT NULL)",
          );
        },
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> insertDataIntoDB(
      Database db, Map<String, dynamic> data, String table) async {
    try {
      await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<NotesModel>> offlineData(Database db, String table) async {
    List<NotesModel> notesData = [];
    try {
      List<Map<String, dynamic>> maps =
          await db.query(table, orderBy: "dateTime");
      if (table == "notes") {
        notesData = List.from(maps.map((e) => NotesModel.fromMap(e)));
      }
    } catch (e) {
      return [];
    }
    return notesData;
  }

  static Future<bool> deleteFromDb(Database db, int id) async {
    try {
      await db.delete("chat", where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteTableFromDb(Database db, String table) async {
    try {
      await db.delete(table);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<int> updateDb(Database db, NotesModel notes) async {
    return await db
        .update("chat", notes.toMap(), where: 'id = ?', whereArgs: [notes.id]);
  }

  static Future close(Database db) async => db.close();
}
