import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../model.dart';

class SQLHelper {
  static sql.Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";
  static final String _dbApp = 'tasks.db';

  static Future<void> createTables(sql.Database database) async {


    //await database.execute("DROP TABLE IF EXISTS $_tableName");

    await database.execute(
        """CREATE TABLE $_tableName(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title STRING, note TEXT, date STRING,
                startTime STRING, endTime STRING,
                remind INTEGER, repeat STRING,
                color INTEGER,
                isCompleted INTEGER
      )
      """);

  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      _dbApp,
      version: _version,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
   int? isCompleted,
   int? color,
   int? remind,
   String title,
   String? note,
   String? date,
   String? startTime,
   String? endTime,
   String? repeat,

  ) async {
    final db = await SQLHelper.db();
    //this prevent us from listing our content as stated in the comment section
    //final data = TaskModel();
    final data = {
      'repeat': repeat,
      'endTime': endTime,
      'startTime': startTime,
      'remind': remind,
      'color': color,
      'isCompleted': isCompleted,
      'note': note,
      'title':title,
      'date': date};
    //return await db.delete(_tableName);
    final id = await db.insert(_tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(_tableName, orderBy: "id");
  }
}
