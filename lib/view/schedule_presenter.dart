import '../data/model/schedule.dart';
import '../data/model/device.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';
import '../data/model/location.dart';

abstract class ScheduleDetailPageContract{
  void onScheduleSaved(List<Location> locations);
  void onScheduleModified(Schedule newSchedule);
  void onScheduleDeleted(List<Location> locations);
}

abstract class AddSchedulePageContract{
  void onScheduleSaved(List<Location> locations);
  void onScheduleModified(Schedule newSchedule);
  void onScheduleDeleted(List<Location> locations);
}

abstract class CheckBoxTileContract{
  void onValueChanged(String day, bool value);
  void onScheduleSaved(Schedule newSchedule);
}

abstract class DeviceDetailPageContract{
  void onSchedulesLoaded(List<Schedule> schedules);
  void onScheduleAdded(List<Location> locations);
}

abstract class ScheduleCardContract{
  void onScheduleUpdated(List<Location> locations);
}

abstract class DayButtonContract{
  void onRepeatPressed(bool value);
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
      (value){
        _view.onRepeatPressed(value);
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
        _view.onScheduleSaved(locations);
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
        _view.onScheduleSaved(locations);
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