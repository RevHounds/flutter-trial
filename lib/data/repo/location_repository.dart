import '../model/location.dart';
import 'dart:async';


List <Location> startingList = 
 <Location> [
   new Location(
     "127.0.0.1",
     "Rumah",
     "http://www.for-example.org/img/main/forexamplelogo.png"
   ),
   new Location(
    "127.0.0.1",
    "Kantor",
    "http://www.for-example.org/img/main/forexamplelogo.png"
   )
 ];

abstract class LocationRepository{
  Future<Location> getLocationByUID(String uid);
  Future<List<Location>> fetch();
  Future<List<Location>> save(Location location);
  Future<List<Location>> addDeviceOnLocation(Device device, Location location);
  Future<Location> changeDeviceStateOnLocation(String location_uid, String device_uid);
}

class MockLocationRepository implements LocationRepository{
  List<Location> locations;

  MockLocationRepository(){
    print("Mock location initialized");
    locations = startingList;
  }

  @override
  Future<Location> getLocationByUID(String uid){
    for (var location in locations) {
      String locationUID = location.uid;
      print("$locationUID is same with $uid");
      if(location.uid == uid) 
        return Future.value(location);
    }
    return Future.value(null);
  }

  @override
  Future<List<Location>> fetch(){
    return new Future.value(locations);
  }

  @override
  Future<List<Location>> addDeviceOnLocation(Device device, Location location){
    String uid = location.uid;
    String name = location.name;
    print("adding device to $name");

    for (int i = 0; i < locations.length; i++) {
      if(uid == locations[i].uid){
        locations[i].devices.add(device);
        return Future.value(locations);
      }
    }
    return Future.value(null);
  }

  @override
  Future<List<Location>> save(Location location){
    locations.add(location);
    print("Location saved");
    return new Future.value(locations);
  }

  @override
  Future<Location> changeDeviceStateOnLocation(String location_uid, String device_uid){
    Location locationFound;
    
    for (var location in locations) {
      if(location.uid == location_uid){
        for(var device in location.devices){
          if(device.uid == device_uid){
            device.status = !device.status;
          }
        }
        locationFound = location;
      }
    }
    Future.value(locationFound);
  }

}
