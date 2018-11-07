import '../model/location.dart';
import 'dart:async';
import '../../database/location_database_wrapper.dart';
import '../../utils/rest-getway.dart';
import '../model/user.dart';

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
  Location findLocationByUID(String uid);
  Future<Location> getLocationByUID(Location location);
  Future<List<Location>> fetch(User user);
  Future<List<Location>> save(Location location);
  Future<List<Location>> addDeviceOnLocation(Device device, Location location);
  Future<Location> changeDeviceStateOnLocation(Device device, Location location);
  Future<Location> deleteLocation(String uid);
}

class ProLocationRepository implements LocationRepository{
  RestGetway getway = new RestGetway();
  List<Location> locations;

  ProLocationRepository(){this.locations = new List<Location>();}

  @override
  Location findLocationByUID(String uid){
    for(Location location in locations){
      if(location.uid == uid)
        return location;
    }
    return null;
  }

  @override
  Future<Location> getLocationByUID(Location location){
    return getway.getDevices(location).then(
      (devices){
        location.devices = devices;
        return Future.value(location);
      }
    );
  }

  @override
  Future<List<Location>> fetch(User user) async {
    return getway.getLocations(user).then(
      (result){
        if(result == null){
          this.locations = new List<Location>();
        } else{
          this.locations = result;
        }
        return Future.value(this.locations);
      }
    );
  }

  @override
  Future<List<Location>> save(Location location){
    return getway.addLocation(location).then(
      (res){
        locations.add(location);
        return Future.value(locations);
      }
    );
  }

  @override
  Future<List<Location>> addDeviceOnLocation(Device device, Location location){
    print("adding this " + device.name);
      return getway.addDevice(device, location).then(
        (device){
          for(int i = 0; i<locations.length; i++){
            if(locations[i].uid == location.uid){
              locations[i].devices.add(device);
            }
          }
          return Future.value(locations);
        }
      );
  }

  @override
  Future<Location> changeDeviceStateOnLocation(Device device, Location location){
    return getway.updateDevice(device, location).then(
        (device){
          for(int i = 0; i<location.devices.length; i++){
            if(location.devices[i].uid == device.uid){
              location.devices[i] = (device);
              return Future.value(location);
            }
          }
        }
      );
  }
  @override
  Future<Location> deleteLocation(String uid){
    print(uid);
    return getway.deleteLocation(uid).then(
      (resId){
        print(resId);
        if(resId == "not found")
          return null;
        return Future.value(locations.removeAt(locations.indexOf(findLocationByUID(uid))));
    });
  }
}

class MockLocationRepository implements LocationRepository{
  List<Location> locations;

  MockLocationRepository(){
    print("Mock location initialized");
    locations = startingList;
  }

  Location findLocationByUID(String uid){
    for(Location location in locations){
      if(location.uid == uid)
        return location;
    }
    return null;
  }

  @override
  Future<Location> getLocationByUID(Location location){
    for (var location in locations) {
      if(location.isEqualWithUID(location.uid)) 
        return Future.value(location);
    }
    return Future.value(null);
  }

  @override
  Future<List<Location>> fetch(User user){
    return Future.value(locations);
  }

  @override
  Future<List<Location>> addDeviceOnLocation(Device device, Location location){
    String name = location.name;
    print("adding device to $name");

    for (int i = 0; i < locations.length; i++) {
      if(locations[i].isEqualWithLocation(location)){
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
  Future<Location> changeDeviceStateOnLocation(Device device, Location location){
    String location_uid = location.uid;
    String device_uid = device.uid;
    Location locationFound = null;
    
    for (var location in locations) {
      if(location.isEqualWithUID(location_uid)){
        for(var device in location.devices){
          if(device.uid == device_uid){
            String name = location.name;
            print("location found, device state changed on $name");
            device.status = !device.status;
            locationFound = location;
            return Future.value(locationFound);
          }
        }
      }
    }
    return Future.value(null);
  }

  @override
  Future<Location> deleteLocation(String uid){
    return Future.value(locations.removeAt(locations.indexOf(findLocationByUID(uid))));
  }
}
