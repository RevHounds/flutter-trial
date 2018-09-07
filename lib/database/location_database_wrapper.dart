import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'init.dart';
import '../data/model/location.dart';
import '../data/model/user.dart';

class LocationDatabaseHelpoer{
  Database _database;
  MainDB db;
  LocationDatabaseHelpoer(){
    db = new MainDB();
    db.getDatabase()
      .then((database){
        _database = database;
      });
  }

  Future<List<Location>> getLocationsByUserId(String userId) async{
    var dbClient = _database;
    
    List<Map> res = await dbClient.rawQuery(
      '''
        SELECT *
        FROM Location
        WHERE ownerId = $userId
      '''
    );
    List<Location> locations;
    for(int i = 0; i<res.length; i++){
      locations.add(new Location.fromMap(res[i]));
    }
    return Future.value(locations);  
  }

  void saveLocation(Location newLocation, User user){
    var dbClient = _database;
    String uid = newLocation.uid;
    String name = newLocation.name;
    String ownerId = user.uid;

    dbClient.rawInsert(
      '''
        INSERT INTO Location (id, ownerId, name)
        VALUES($uid, $ownerId, $name)
      '''
    );
  }

  void updateLocation(Location newLocation, User user){
    var dbClient = _database;
    String uid = newLocation.uid;
    String name = newLocation.name;

    dbClient.rawQuery(
      '''
        UPDATE Location
        SET
          name = $name
        WHERE 
          id = $uid
      '''
    );
  }

  void deleteLocation(String uid){
    var dbClient = _database;
    
    dbClient.rawQuery(
      '''
      DELETE Location
      WHERE
        id = $uid
      '''
    );
  }
}
