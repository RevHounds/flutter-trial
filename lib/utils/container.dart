import 'package:flutter/material.dart';
import '../data/model/location.dart';
import '../data/model/user.dart';
import '../data/model/schedule.dart';
import '../data/model/device.dart';
import '../data/model/trigger.dart';

class StateContainer extends StatefulWidget{
  Location onFocusLocation;
  Schedule onFocusSchedule;
  Device onFocusDevice;
  Trigger onFocusTrigger;
  List<Location> locations;
  List<Device> outputs;
  Widget child;
  User user;
  bool errorLogin = false;
  bool loggedIn = false;
  
  StateContainer(this.child) : locations = new List();

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedStateContainer)
            as InheritedStateContainer).data;
  }

  @override
  State<StateContainer> createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer>{
  List<Location> locations;
  List<Device> outputs;
  Location onFocusLocation;
  Schedule onFocusSchedule;
  Trigger onFocusTrigger;
  Device onFocusDevice;
  User user;
  bool errorLogin = false;
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    print("Inherited Widget is initialized");

    return new InheritedStateContainer(
      this,         //data passed down
      widget.child  //child
    );
  }

  void deleteLocation(Location location){
    locations.remove(location);
  }
  
  Location findLocationByUID(String uid){
    for (var location in locations) {
      if(location.uid == uid){
        onFocusLocation = location;
        return location;
      }
    }
    return null;
  }
  
}

class InheritedStateContainer extends InheritedWidget{
  final StateContainerState data;

  InheritedStateContainer(this.data, Widget child) : super(child: child){
  }

  @override
  bool updateShouldNotify(InheritedStateContainer old) => data != old.data;
}