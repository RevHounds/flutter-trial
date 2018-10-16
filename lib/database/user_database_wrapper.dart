import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'init.dart';
import '../data/model/user.dart';

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

  void saveUser(User newUser){
    var dbClient = _database;
    String uid = newUser.uid;
    String name = newUser.name;
    String password = newUser.password;
    String email = newUser.email;

    dbClient.rawInsert(
      '''
        INSERT INTO User (id, name, password, email)
        VALUES($uid, $name, $password, $email)
      '''
    );
  }

  void updateUser(User newUser){
    var dbClient = _database;
    String uid = newUser.uid;
    String name = newUser.name;
    String password = newUser.password;
    String email = newUser.email;

    dbClient.rawQuery(
      '''
        UPDATE User
        SET
          name = $name,
          password = $password,
          email = $email
        WHERE
          uid = $uid
      '''
    );
  }

  Future<bool> isLoggedIn() async{
    var dbClient = _database;
    var res = await dbClient.query("User");
    return res.length > 0;
  }
}
