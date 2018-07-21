import 'package:flutter/material.dart';
import '../data/model/location.dart';


class StateContainer extends StatefulWidget{
  Location onFocusLocation;
  List<Location> locations;
  Widget child;
  
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
  Location onFocusLocation;
  int count;

  @override
  Widget build(BuildContext context) {
    print("Inherited Widget is initialized");

    count = 1;

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
  }
  
}

class InheritedStateContainer extends InheritedWidget{
  final StateContainerState data;

  InheritedStateContainer(this.data, Widget child) : super(child: child){
    int n = data.count;
    print("Shit called, and not null, count: $n");
  }

  @override
  bool updateShouldNotify(InheritedStateContainer old) => data != old.data;
}