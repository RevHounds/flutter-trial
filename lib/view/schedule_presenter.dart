import '../data/model/schedule.dart';
import '../data/model/device.dart';
import '../data/repo/location_repository.dart';
import '../data/model/location.dart';
import '../data/model/trigger.dart';
import '../utils/injector.dart';

abstract class ScheduleDetailPageContract{
  void onScheduleSaved(List<Location> locations, Device device);
  void onScheduleModified(Schedule newSchedule);
  void onScheduleDeleted(List<Location> locations);
}

abstract class TriggerDetailContract{
  void onTriggerSaved(List<Location> locations, Device device);
  void onTriggerModified(Trigger newTrigger);
  void onTriggerDeleted(List<Location> locations);
}

abstract class AddSchedulePageContract{
  void onScheduleSaved(List<Location> locations, Device device);
  void onScheduleModified(Schedule newSchedule);
  void onScheduleDeleted(List<Location> locations);
}

abstract class AddTriggerPageContract{
  void onTriggerSaved(List<Location> locations, Device device);
  void onTriggerModified(Trigger newTrigger);
  void onTriggerDeleted(List<Location> locations);
}

abstract class CheckBoxTileContract{
  void onValueChanged(String day, bool value);
  void onScheduleSaved(Schedule newSchedule);
}

abstract class DeviceDetailPageContract{
  void onSchedulesLoaded(List<Schedule> schedules);
  void onScheduleAdded(List<Location> locations);
}

abstract class DeviceTriggerPageContract{
  void onTriggersLoaded(List<Trigger> triggers);
  void onTriggerAdded(List<Location> locations);
}

abstract class ScheduleCardContract{
  void onScheduleUpdated(List<Location> locations);
}

abstract class TriggerCardContract{
  void onTriggerUpdated(List<Location> locations);
}

abstract class DayButtonContract{
  void onRepeatPressed(Schedule newSchedule);
}

abstract class TimeCardContract{
  void onTimeChanged(String time, Schedule schedule);
}

class DayButtonPresenter{
  DayButtonContract _view;
  LocationRepository _repo;

  DayButtonPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void selectDay(String day, Schedule schedule){
    _repo.changeRepeatOnSchedule(day, schedule).then(
      (newSchedule){
        _view.onRepeatPressed(newSchedule);
      }
    );
  }
}

class AddSchedulePagePresenter{
  AddSchedulePageContract _view;
  LocationRepository _repo;

  AddSchedulePagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void modifySchedule(Schedule schedule){
    _view.onScheduleModified(schedule);
  }


  void changeIsRanged(Schedule schedule){
    schedule.isRanged = !schedule.isRanged;
    _view.onScheduleModified(schedule);
  }

  void saveSchedule(Schedule schedule, Device device){
    _repo.addScheduleOnDevice(schedule, device).then(
      (locations){
        Device newDevice;
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid == locations[i].devices[j].uid)
              newDevice = locations[i].devices[j];
          }
        }
        _view.onScheduleSaved(locations, newDevice);
      }
    );
  }

  void deleteSchedule(Schedule schedule, Device device){
    _repo.deleteScheduleOnDevice(schedule, device).
      then((locations){
        _view.onScheduleDeleted(locations);
      });
  }
}

class AddTriggerPagePresenter{
  AddTriggerPageContract _view;
  LocationRepository _repo;

  AddTriggerPagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void modifySchedule(Trigger trigger){
    _view.onTriggerModified(trigger);
  }

  void saveTrigger(Trigger trigger, Device device){
    _repo.addTriggerOnDevice(trigger, device).then(
      (locations){
        Device newDevice;
        for(int i = 0; i<locations.length; i++){
          for(int j = 0; j<locations[i].devices.length; j++){
            if(device.uid == locations[i].devices[j].uid)
              newDevice = locations[i].devices[j];
          }
        }
        _view.onTriggerSaved(locations, newDevice);
      }
    );
  }

  void deleteTrigger(Trigger trigger, Device device){
    _repo.deleteTriggerOnDevice(trigger, device).
      then((locations){
        _view.onTriggerDeleted(locations);
      });
  }
}

class TimeCardPresenter{
  TimeCardContract _view;
  LocationRepository _repo;

  TimeCardPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void changeTime(String determiner, String time, Schedule schedule){
    determiner = determiner.toLowerCase();
    if(determiner == "start"){
      schedule.start = time;
    } else{
      schedule.end = time;
    }

    _view.onTimeChanged(time, schedule);
  }
}

class ScheduleDetailPagePresenter{
  ScheduleDetailPageContract _view;
  LocationRepository _repo;

  ScheduleDetailPagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void modifySchedule(Schedule schedule){
    _view.onScheduleModified(schedule);
  }

  void saveSchedule(Schedule schedule, Device device){
    _repo.updateScheduleOnDevice(schedule, device).then(
      (locations){
        _view.onScheduleSaved(locations, device);
      }
    );
  }

  void deleteSchedule(Schedule schedule, Device device){
    _repo.deleteScheduleOnDevice(schedule, device).
      then((locations){
        _view.onScheduleDeleted(locations);
      });
  }
}

class TriggerDetailPresenter{
  TriggerDetailContract _view;
  LocationRepository _repo;

  TriggerDetailPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void modifyTrigger(Trigger trigger){
    _view.onTriggerModified(trigger);
  }

  void saveTrigger(Trigger trigger, Device device){
    _repo.updateTriggerOnDevice(trigger, device).then(
      (locations){
        _view.onTriggerSaved(locations, device);
      }
    );
  }

  void deleteTrigger(Trigger trigger, Device device){
    _repo.deleteTriggerOnDevice(trigger, device).
      then((locations){
        _view.onTriggerDeleted(locations);
      });
  }
}

class CheckBoxTilePresenter{
  CheckBoxTileContract _view;
  LocationRepository _repo;

  CheckBoxTilePresenter(this._view){
    this._repo = new Injector().locationRepository;
  }
  void saveSchedule(Schedule newSchedule, Device device){
    _repo.updateScheduleOnDevice(newSchedule, device).then(
      (res){
        _view.onScheduleSaved(newSchedule);
    });
  }

  void changeValue(String title, bool value){

  }

  void deleteSchedule(Schedule schedule, Device device){
    _repo.updateScheduleOnDevice(schedule, device).then(
      (res){
        _view.onScheduleSaved(schedule);
    });
  }
}

class CheckboxTilePresenter{
  CheckBoxTileContract _view;
  LocationRepository _repo;

  CheckboxTilePresenter(this._view){
    this._repo = new Injector().locationRepository;
  }

  void changeValue(String title, bool value){
    _view.onValueChanged(title, value);
  }

  void saveSchedule(Schedule newSchedule, Device device){
    _repo.updateScheduleOnDevice(newSchedule, device).then(
      (res){
        _view.onScheduleSaved(newSchedule);
    });
  }

  void deleteSchedule(Schedule schedule, Device device){
    _repo.updateScheduleOnDevice(schedule, device).then(
      (res){
        _view.onScheduleSaved(schedule);
    });
  }
}

class DeviceDetailPagePresenter{
  DeviceDetailPageContract _view;
  LocationRepository _repo;

  DeviceDetailPagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void deleteDevice(Device device){
    _repo.deleteDevice(device);
  }

  void addSchedule(Device device){
    _repo.addScheduleOnDevice(new Schedule(), device).then(
      (locations){
        this._view.onScheduleAdded(locations);
      }
    );
  }

  void loadSchedules(Device device){
    _repo.getSchedules(device).then(
      (schedules){
        this._view.onSchedulesLoaded(schedules);
      }
    );
  }
}

class DeviceTriggerPagePresenter{
  DeviceTriggerPageContract _view;
  LocationRepository _repo;

  DeviceTriggerPagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void deleteDevice(Device device){
    _repo.deleteDevice(device);
  }

  void addTrigger(Trigger trigger, Device device){
    _repo.addTriggerOnDevice(trigger, device).then(
      (locations){
        this._view.onTriggerAdded(locations);
      }
    );
  }

  void loadTriggers(Device device){
    _repo.getTriggers(device).then(
      (triggers){
        this._view.onTriggersLoaded(triggers);
      }
    );
  }
}

class ScheduleCardPresenter{
  ScheduleCardContract _view;
  LocationRepository _repo;

  ScheduleCardPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void saveSchedule(Schedule newSchedule, Device device){
    _repo.updateScheduleOnDevice(newSchedule, device).then(
      (schedule){
        _view.onScheduleUpdated(schedule);
      }
    );
  }
}

class TriggerCardPresenter{
  TriggerCardContract _view;
  LocationRepository _repo;

  TriggerCardPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void saveTrigger(Trigger newTrigger, Device device){
    _repo.updateTriggerOnDevice(newTrigger, device).then(
      (trigger){
        _view.onTriggerUpdated(trigger);
      }
    );
  }
}