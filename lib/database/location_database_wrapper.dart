import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'init.dart';
import '../data/model/location.dart';
import '../data/model/user.dart';

class LocationDatabaseHelper{
  Database _database;
  MainDB db;
  LocationDatabaseHelper(){
    db = new MainDB();
    db.getDatabase()
      .then((database){
        _database = database;
      });
  }

  Future<List<Location>> getLocations() async{
    var dbClient = _database;
    
    List<Map> res = await dbClient.rawQuery(
      '''
        SELECT *
        FROM Location
      '''
    );
    List<Location> locations;
    for(int i = 0; i<res.length; i++){
      locations.add(new Location.fromMap(res[i]));
    }
    return Future.value(locations);  
  }

  Future<Location> saveLocation(Location newLocation) async {
    var dbClient = _database;
    String uid = newLocation.uid;
    String name = newLocation.name;

    await dbClient.rawInsert(
      '''
        INSERT INTO Location (id, name)
        VALUES($uid, $name)
      '''
    );

    return Future.value(newLocation);
  }

  Future<Location> updateLocation(Location newLocation, User user) async {
    var dbClient = _database;
    String uid = newLocation.uid;
    String name = newLocation.name;

    await dbClient.rawQuery(
      '''
        UPDATE Location
        SET
          name = $name
        WHERE 
          id = $uid
      '''
    );

    return Future.value(newLocation);
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
