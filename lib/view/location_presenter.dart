import '../data/repo/location_repository.dart';
import '../utils/injector.dart';
import '../data/model/user.dart';
import '../data/model/location.dart';
import '../data/model/device.dart';

abstract class LocationListContract{
  void onLoadLocationComplete(List<Location> locations);
  void onErrorLoadLocation();
}

abstract class AddLocationContract{
  void onSaveLocation(List<Location> locations);
}

abstract class LocationDetailContract{
  void onLoadLocation(Location location);
  void onChangeState(List<Location> locations);
}

abstract class LocationDetailAppBarContract{
  void onDeleteLocation(List<Location> location);
}

abstract class LocationPairingStatusContract{
  void onPairingFinished(Location locations);
  void onPairingNotFinished(Location locations);
}

abstract class OutputDeviceTileStateContract{
  void onDeviceStateChanged(device);
}

class LocationListPresenter{
  LocationListContract _view;
  LocationRepository _repo;

  LocationListPresenter(LocationListContract this._view){
    this._repo = Injector().locationRepository;
  }

  void loadLocations(User user){
    assert(_view != null);

    _repo.getLocationsOfUser(user)
      .then((locations){
          if(locations == null){
            _view.onErrorLoadLocation();
            return;
          }
          int n = locations.length;
          print("Location fetched, count: $n");
          _view.onLoadLocationComplete(locations);
      });
  }
}

class AddLocationPresenter{
  LocationRepository _repo;
  AddLocationContract _view;

  AddLocationPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void saveLocation(LocationAddView newLocation){
    Location location = Location.fromView(newLocation);
    print("Location created");
    
    _repo.saveLocation(location).
      then((locations){
        int n = locations.length;
        print("Location saved! count: $n");
        _view.onSaveLocation(locations);
      });
  }
}

class OutputDevicePresenter{
  LocationRepository _repo;
  OutputDeviceTileStateContract _view;

  OutputDevicePresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void changeDeviceStatus(Device device, bool value){
    _repo.changeDeviceState(device, value).then(
      (device){
        _view.onDeviceStateChanged(device);
      }
    );
  }
}

class LocationDetailPresenter{
  LocationRepository _repo;
  LocationDetailContract _view;

  LocationDetailPresenter(this._view){
    this._repo = Injector().locationRepository;
  }
  
   void loadLocationByUID(Location location){
    String uid = location.uid;
    print("ini lagi cobain cari si $uid");

    _repo.getDevicesOnLocation(location)
      .then((location){
        print("location found!");
        _view.onLoadLocation(location);
      });
  }
}

class LocationAppBarPresenter{
  LocationRepository _repo = Injector().locationRepository;
  LocationDetailAppBarContract _view;

  LocationAppBarPresenter(this._view);

  void deleteLocation(String uid){
    _repo.deleteLocation(uid)
      .then((locations){ 
        _view.onDeleteLocation(locations);
      });
  }
}

class LocationPairingPresenter{
  LocationRepository _repo = Injector().locationRepository;
  LocationPairingStatusContract _view;

  LocationPairingPresenter(this._view);

  void checkStatus(Location location){
    _repo.getLocationPairingStatus(location).then(
      (status){
        if(status){
          _view.onPairingFinished(location);
        } else{
          _view.onPairingNotFinished(location);
        }
      });
  }
}