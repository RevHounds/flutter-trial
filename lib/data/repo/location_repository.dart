import '../model/location.dart';
import 'dart:async';
import '../model/device.dart';
import '../../utils/rest-getway.dart';
import '../model/user.dart';
import '../model/schedule.dart';
import '../model/trigger.dart';

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
  Future<Device> changeDeviceState(Device device, bool value);
  Future<List<Location>> deleteLocation(String uid);
  Future<List<Location>> deleteDevice(Device device);
  Future<List<Schedule>> getSchedules(Device device);
  Future<List<Location>> addScheduleOnDevice(Schedule schedule, Device device);
  Future<List<Location>> updateScheduleOnDevice(Schedule schedule, Device device);
  Future<List<Location>> deleteScheduleOnDevice(Schedule schedule, Device device);
  Future<List<Trigger>> getTriggers(Device device);
  Future<List<Location>> addTriggerOnDevice(Trigger trigger, Device device);
  Future<List<Location>> updateTriggerOnDevice(Trigger trigger, Device device);
  Future<List<Location>> deleteTriggerOnDevice(Trigger trigger, Device device);
  Future<Schedule> changeRepeatOnSchedule(String day, Schedule schedule);
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
        (newDevice){
          for(int i = 0; i<locations.length; i++){
            if(locations[i].uid == location.uid){
              locations[i].devices.add(newDevice);
            }
          }
          return Future.value(locations);
        }
      );
  }

  @override
  Future<Device> changeDeviceState(Device device, bool value){
    device.status = value;
    return getway.updateDevice(device).then(
      (device){
        return Future.value(device);
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
  Future<List<Location>> addScheduleOnDevice(Schedule schedule, Device device){
    return getway.addSChedule(schedule, device).then(
      (newSchedule){
        device.schedules.add(schedule);
      
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid == locations[i].devices[j].uid){
              locations[i].devices[j] = device;
              return locations;
            }
          }
        }
        return Future.value(locations);
      }
    );
  }

  @override
  Future<List<Location>> updateScheduleOnDevice(Schedule schedule, Device device){ 
    return getway.updateSchedule(schedule, device).then(
      (newSchedule){
        if (newSchedule == null)
          return this.locations;
        
        for(int i = 0; i<device.schedules.length; i++){
          if(schedule.uid == device.schedules[i].uid){
            device.schedules[i] = schedule;
          }
        }

        for(int j = 0; j<locations.length; j++){
          for(int i = 0; i<locations[j].devices.length; i++){
            if(device.uid == locations[j].devices[i].uid){
              locations[j].devices[i] = device;
              return locations;
            }
          }
        }
        return locations;
      }
    );
  }

  @override
  Future<List<Location>> deleteScheduleOnDevice(Schedule schedule, Device device){
    getway.deleteSchedule(schedule.uid)
      .then((uid){
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid != locations[i].devices[j].uid) 
              continue;
            for(int k = 0; k<locations[j].devices[j].schedules.length; k++){
              if(schedule.uid != locations[j].devices[j].schedules[k].uid)
                continue;
              locations[j].devices[j].schedules.removeAt(k);
              return Future.value(locations);
            }
          }
        }
     });
  }

  @override
  Future<Schedule> changeRepeatOnSchedule(String day, Schedule schedule){
    Schedule temp = schedule;
    temp.changeValue(day, !temp.repeatDay[day]);
    print(temp.repeat);
    schedule = temp;
    return Future.value(schedule);
  }

  @override
  Future<List<Trigger>> getTriggers(Device device){
    return getway.getTriggers(device).then(
      (triggers){
        return Future.value(triggers);
      }
    );
  }

  @override
  Future<List<Location>> addTriggerOnDevice(Trigger trigger, Device device){
    return getway.addTrigger(trigger, device).then(
      (newtrigger){
        device.triggers.add(trigger);
      
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid == locations[i].devices[j].uid){
              locations[i].devices[j] = device;
              return locations;
            }
          }
        }
        return Future.value(locations);
      }
    );
  }

  @override
  Future<List<Location>> updateTriggerOnDevice(Trigger trigger, Device device){ 
    return getway.updateTrigger(trigger, device).then(
      (newtrigger){
        if (newtrigger == null)
          return this.locations;
        
        for(int i = 0; i<device.triggers.length; i++){
          if(trigger.uid == device.triggers[i].uid){
            device.triggers[i] = trigger;
          }
        }

        for(int j = 0; j<locations.length; j++){
          for(int i = 0; i<locations[j].devices.length; i++){
            if(device.uid == locations[j].devices[i].uid){
              locations[j].devices[i] = device;
              return locations;
            }
          }
        }
        return locations;
      }
    );
  }

  @override
  Future<List<Location>> deleteTriggerOnDevice(Trigger trigger, Device device){
    getway.deleteTrigger(trigger.uid)
      .then((uid){
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid != locations[i].devices[j].uid) 
              continue;
            for(int k = 0; k<locations[j].devices[j].triggers.length; k++){
              if(trigger.uid != locations[j].devices[j].triggers[k].uid)
                continue;
              locations[j].devices[j].triggers.removeAt(k);
              return Future.value(locations);
            }
          }
        }
     });
  }

}
