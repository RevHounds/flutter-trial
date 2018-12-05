import '../data/model/schedule.dart';
import '../data/model/device.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';

abstract class CheckBoxTileContract{
  void onValueChanged(String day, bool value);
  void onScheduleSaved(Schedule newSchedule);
}

abstract class DeviceDetailPageContract{
  void onSchedulesLoaded(List<Schedule> schedules);
  void onScheduleAdded(Schedule schedule);
}

abstract class ScheduleCardContract{
  void onScheduleUpdated(Schedule schedule);
}

class CheckBoxTilePresenter{
  CheckBoxTileContract _view;
  LocationRepository _repo;

  CheckBoxTilePresenter(this._view){
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
}

class DeviceDetailPagePresenter{
  DeviceDetailPageContract _view;
  LocationRepository _repo;

  DeviceDetailPagePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void addSchedule(Device device){
    _repo.addScheduleOnDevice(new Schedule(), device).then(
      (schedule){
        this._view.onScheduleAdded(schedule);
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