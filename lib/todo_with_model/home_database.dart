import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'home_model.dart';
import 'package:path_provider/path_provider.dart';

class SQLHelper {
  static sql.Database? _db;
  static final int _version = 1;
  static final String _tableName = "home_tasks";
  static final String _dbApp = 'home_tasks.db';

  static Future<void> createTables(sql.Database database) async {


    //await database.execute("DROP TABLE IF EXISTS $_tableName");

    await database.execute(
        """CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              title TEXT,
              details TEXT,
              createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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
  static Future<int> createItem(Task task) async {
    final db = await SQLHelper.db();
    //this prevent us from listing our content as stated in the comment section
    //final data = TaskModel();
    //final data = {};
    //return await db.delete(_tableName);
    final id = await db.insert(_tableName, task.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(_tableName, orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  // static Future<int> updateItem(
  //     int id, String title, String? descrption) async {
  //   final db = await SQLHelper.db();
  //
  //   final data = {
  //     'title': title,
  //     'description': descrption,
  //     'createdAt': DateTime.now().toString()
  //   };
  //
  //   final result =
  //   await db.update('items', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
