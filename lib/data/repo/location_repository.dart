import '../model/location.dart';
import 'dart:async';

abstract class LocationRepository{
  Future<List<Location>> fetch();
  Future<List<Location>> save(Location location);
}

class MockLocationRepository implements LocationRepository{
  List<Location> locations;

  MockLocationRepository(){
    locations = startingList;
  }

  @override
  Future<List<Location>> fetch(){
    return new Future.value(locations);
  }

  @override
  Future<List<Location>> save(Location location){
    locations.add(location);
    print("Location saved");
    return new Future.value(locations);
  }

}

var startingList = 
 <Location> [
   Location(
     "127.0.0.1",
     "Rumah",
     "http://www.for-example.org/img/main/forexamplelogo.png"
   ),
   Location(
    "127.0.0.1",
    "Kantor",
    "http://www.for-example.org/img/main/forexamplelogo.png"
   )
 ];