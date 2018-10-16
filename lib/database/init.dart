import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MainDB{
  static Database _database;

  Future<Database> getDatabase() async{
    if(_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "macharoon.db");
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE DATABASE User(
          id TEXT PRIMARY KEY,
          name TEXT,
          password TEXT, 
          email TEXT
        );

        CREATE DATABASE Location(
          id TEXT PRIMARY KEY,
          FOREIGN KEY(ownerId) REFERENCES User(id),
          name TEXT
        );

        CREATE DATABASE PiBoards(
          id TEXT PRIMARY KEY,
          FOREIGN KEY(locationId) REFERENCES Location(id),
          address TEXT
        );

        CREATE DATABASE Device(
          id TEXT PRIMARY KEY,
          FOREIGN KEY(piId) REFERENCES PiBoards(id),
          name TEXT
        )

        CREATE DATABASE Schedule(
          id TEXT PRIMARAY KEY,
          FOREIGN KEY(equipmentId) REFERENCES Device(id),
          startTime TEXT,
          endTime TEXT,
          day TEXT
        )
      '''
    );
    print("Database Created");
  }

  
}
