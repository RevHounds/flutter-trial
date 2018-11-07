import '../data/model/location.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';
import '../data/model/user.dart';

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

abstract class LocationDetailAppBarContract{
  void onDeleteLocation(Location location);
}

class LocationListPresenter{
  LocationListContract _view;
  LocationRepository _repo;

  LocationListPresenter(LocationListContract this._view){
    this._repo = Injector().locationRepository;
  }

  void loadLocations(User user){
    assert(_view != null);

    _repo.fetch(user)
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

  void loadLocationByUID(Location location){
    String uid = location.uid;
    print("ini lagi cobain cari si $uid");

    _repo.getLocationByUID(location)
      .then((location){
        print("location found!");
        _view.onLoadLocation(location);
      });
  }

  void changeState(Location location, Device device){
    _repo.changeDeviceStateOnLocation(device, location)
        .then((location){
          _view.onChangeState(location);
        });
  }
}

class LocationAppBarPresenter{
  LocationRepository _repo = Injector().locationRepository;
  LocationDetailAppBarContract _view;

  LocationAppBarPresenter(this._view);

  void deleteLocation(String uid){
    _repo.deleteLocation(uid)
      .then((location){ 
        _view.onDeleteLocation(location);
      });
  }
}