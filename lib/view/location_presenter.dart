import '../data/model/location.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';


abstract class LocationListContract{
  void onLoadLocationComplete(List<Location> locations);
  void onErrorLoadLocation();
}

abstract class AddLocationContract{
  void onSaveLocation(List<Location> locations);
}

abstract class LocationDetailContract{
  void onLoadLocation(Location location);
  void onChangeState(Location location);
}

class LocationListPresenter{
  LocationListContract _view;
  LocationRepository _repo;

  LocationListPresenter(LocationListContract this._view){
    this._repo = Injector().locationRepository;
  }

  void loadLocations(){
    assert(_view != null);

    _repo.fetch()
        .then((locations){
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
    
    _repo.save(location).then((locations){
      int n = locations.length;
      print("Location saved! count: $n");
      _view.onSaveLocation(locations);
    });
  }
}

class LocationDetailPresenter{
  LocationRepository _repo;
  LocationDetailContract _view;

  LocationDetailPresenter(this._view){
    this._repo = Injector().locationRepository;
  }

  void loadLocationByUID(String uid){
    print("ini lagi cobain cari si $uid");
    _repo.getLocationByUID(uid)
      .then((location){
        print("location found!");
        _view.onLoadLocation(location);
      });
  }

  void changeState(Location location, Device device){
    String location_uid = location.uid;
    String device_uid = device.uid;
    _repo.changeDeviceStateOnLocation(location_uid, device_uid)
        .then((location){
          _view.onChangeState(location);
        });
  }
}