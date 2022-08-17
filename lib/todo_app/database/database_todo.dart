import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static sql.Database? _db;
  static final int _version = 1;
  static final String _tableName = "task";
  static final String _dbApp = 'task.db';

  static Future<void> initDb()async{
    if(_db != null){
      return;
    }
    try{
      //String _path
      _db = await openDatabase(
        _tableName,
        version: _version,
        onCreate: (db, version){
          print("Creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, data STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)",

          );
        }
      );
    } catch (e){
      print(e);
    }
  }
}