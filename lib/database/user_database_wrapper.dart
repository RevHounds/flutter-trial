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

  Future<User> getUser(String email, String password) async{
    var dbClient = _database;
    
    List<Map> res = await dbClient.rawQuery(
      '''
        SELECT *
        FROM User
        WHERE User.email = $email AND User.password = $password
      '''
    );
    if(res == null)
      return Future.value(null);
    
    Map user = res.first;
    User foundUser = new User.fromMap(user);
    return Future.value(foundUser);
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

  void deleteUser(String uid){
    var dbClient = _database;

    dbClient.rawQuery(
      ''' 
      DELETE User
      WHERE
        id = $uid
      '''
    );
  }
}
