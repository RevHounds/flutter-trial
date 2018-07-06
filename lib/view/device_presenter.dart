import 'package:flutter/material.dart';
import '../data/model/location.dart';
import '../data/repo/location_repository.dart';
import '../utils/injector.dart';

abstract class AddDevicePageContract{
  void onAddDevice(List<Location> locations);
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