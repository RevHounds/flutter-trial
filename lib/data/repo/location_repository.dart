import '../model/location.dart';
import 'dart:async';
import '../model/device.dart';
import '../../utils/rest-getway.dart';
import '../model/user.dart';
import '../model/schedule.dart';

List <Location> startingList = 
 <Location> [
   new Location(
     "asd",
     "Rumah",
     "http://www.for-example.org/img/main/forexamplelogo.png"
   ),
   new Location(
     "asd",
    "Kantor",
    "http://www.for-example.org/img/main/forexamplelogo.png"
   )
 ];

abstract class LocationRepository{
  Location findLocationByUID(String uid);
  Future<Location> getDevicesOnLocation(Location location);
  Future<bool> getLocationPairingStatus(Location location);
  Future<List<Location>> getLocationsOfUser(User user);
  Future<List<Location>> saveLocation(Location location);
  Future<List<Location>> addDeviceOnLocation(Device device, Location location);
  Future<List<Location>> changeDeviceStateOnLocation(Device device, Location location);
  Future<List<Location>> deleteLocation(String uid);
  Future<List<Location>> deleteDevice(Device device);
  Future<List<Schedule>> getSchedules(Device device);
  Future<Schedule> addScheduleOnDevice(Schedule schedule, Device device);
  Future<Schedule> updateScheduleOnDevice(Schedule schedule, Device device);
  void deleteScheduleOnDevice(Schedule schedule, Device device);
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
  Future<Location> getDevicesOnLocation(Location location){
    return getway.getDevices(location).then(
      (devices){
        location.devices = devices;
        return Future.value(location);
      }
    );
  }

  @override
  Future<bool> getLocationPairingStatus(Location location){
    return getway.getPairingStatus(location).then(
      (status){
        return Future.value(status);
      }
    );
  }

  @override
  Future<List<Location>> getLocationsOfUser(User user) async {
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
  Future<List<Location>> saveLocation(Location location){
    return getway.addLocation(location).then(
      (res){
        print("location count: " + locations.length.toString());

        if(res == null){
          return Future.value(locations);
        }
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
  Future<List<Location>> changeDeviceStateOnLocation(Device device, Location location){
    return getway.updateDevice(device, location).then(
      (device){
        for(int j = 0; j<locations.length; j++){
          for(int i = 0; i<locations[j].devices.length; i++){
            if(locations[j].devices[i].uid == device.uid){
              locations[j].devices[i] = device;
            }
          }
        }
        return Future.value(locations);
      }
    );
  }

  @override
  Future<List<Location>> deleteLocation(String uid){
    print(uid);
    return getway.deleteLocation(uid).then(
      (isSuccess){
        print(isSuccess);
        if(!isSuccess){
          return locations;
        }
        locations.removeAt(locations.indexOf(findLocationByUID(uid)));
        return Future.value(locations);
    });
  }

  @override
  Future<List<Location>> deleteDevice(Device device){
    return getway.deleteDevice(device.uid).then(
      (isSuccess){
        if(!isSuccess){
          return locations;
        }
                
        for(int j = 0; j<locations.length; j++){
          for(int i = 0; i<locations[j].devices.length; i++){
            if(locations[j].devices[i].uid == device.uid){
              locations[j].devices.removeAt(i);
            }
          }
        }
        return Future.value(locations);
    });
  }

  @override
  Future<List<Schedule>> getSchedules(Device device){
    return getway.getSchedules(device).then(
      (schedules){
        return Future.value(schedules);
      }
    );
  }

  @override
  Future<Schedule> addScheduleOnDevice(Schedule schedule, Device device){
    return getway.addSChedule(schedule, device).then(
      (newSchedule){
        return Future.value(newSchedule);
      }
    );
  }

  @override
  Future<Schedule> updateScheduleOnDevice(Schedule schedule, Device device){
    return getway.updateSchedule(schedule, device).then(
      (newSchedule){
        return Future.value(newSchedule);
      }
    );
  }

  @override
  void deleteScheduleOnDevice(Schedule schedule, Device device){
    getway.deleteSchedule(schedule.uid);
  }
}

class MockLocationRepository implements LocationRepository{
  List<Location> locations;
  RestGetway getway;

  @override
    Future<List<Location>> deleteDevice(Device device) {
      // TODO: implement deleteDevice
      return null;
    }

  @override
  Future<bool> getLocationPairingStatus(Location location) {
      // TODO: implement getLocationPairingStatus
      return null;
    }

  @override
  Future<List<Schedule>> getSchedules(Device device){
    return getway.getSchedules(device).then(
      (schedules){
        return Future.value(schedules);
      }
    );
  }

  @override
  Future<Schedule> addScheduleOnDevice(Schedule schedule, Device device){
    return getway.addSChedule(schedule, device).then(
      (newSchedule){
        return Future.value(newSchedule);
      }
    );
  }

  @override
  Future<Schedule> updateScheduleOnDevice(Schedule schedule, Device device){
    return getway.updateSchedule(schedule, device).then(
      (newSchedule){
        return Future.value(newSchedule);
      }
    );
  }

  @override
  void deleteScheduleOnDevice(Schedule schedule, Device device){
    getway.deleteSchedule(schedule.uid);
  }

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
  Future<Location> getDevicesOnLocation(Location location){
    for (var location in locations) {
      if(location.isEqualWithUID(location.uid)) 
        return Future.value(location);
    }
    return Future.value(null);
  }

  @override
  Future<List<Location>> getLocationsOfUser(User user){
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
  Future<List<Location>> saveLocation(Location location){
    locations.add(location);
    print("Location saved");
    return new Future.value(locations);
  }

  @override
  Future<List<Location>> changeDeviceStateOnLocation(Device device, Location location){
    for(int j = 0; j<locations.length; j++){
      for(int i = 0; i<locations[j].devices.length; i++){
        if(locations[j].devices[i].uid == device.uid){
          locations[j].devices[i] = device;
        }
      }
    }
    return Future.value(locations);
  }

  @override
  Future<List<Location>> deleteLocation(String uid){
    locations.removeAt(locations.indexOf(findLocationByUID(uid)));
    return Future.value(locations);
  }
}
