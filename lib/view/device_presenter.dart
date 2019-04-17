import '../data/model/location.dart';
import '../data/model/device.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';

abstract class AddDevicePageContract{
  void onAddDevice(List<Location> locations);
}

abstract class OutputDeviceTileContract{
  void onStateChanged(Device device);
}

class AddDevicePresenter{
    AddDevicePageContract _view;
    LocationRepository _repo;

    AddDevicePresenter(this._view){
      this._repo = Injector().locationRepository;
    }

    saveDeviceOnLocation(Device device, Location location){
      _repo.addDeviceOnLocation(device, location)
        .then((locations){
          _view.onAddDevice(locations);
        });
    }
}

class OutputDeviceTilePresenter{
  OutputDeviceTileContract _view;
  LocationRepository _repo;

  OutputDeviceTilePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  changeDeviceState(Device device, bool status){
    _repo.changeDeviceState(device, status).then((device){
      this._view.onStateChanged(device);
    });
  }
}