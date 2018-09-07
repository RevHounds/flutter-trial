import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'init.dart';
import '../data/model/userModel.dart';
import '../data/model/location.dart';

class UserDatabaseHelpoer{
  Database _database;
  MainDB db;
  UserDatabaseHelpoer(){
    db = new MainDB();
    db.getDatabase()
      .then((database){
        _database = database;
      });
  }

  Future<UserModel>(String email, String password) async{
    var dbClient = await _database;
    
    List<Map> res = await dbClient.rawQuery(
      '''
        SELECT *
        FROM User
        WHERE User.email = $email AND User.password = $password
      '''
    );
    if(res != null){
      Map user = res.first;
      UserModel foundUser = new UserModel.fromMap(user);
      return foundUser;
    }
    return null;
  }
}
