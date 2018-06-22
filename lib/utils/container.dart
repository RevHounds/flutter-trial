import 'package:flutter/material.dart';
import '../data/model/location.dart';


class StateContainer extends StatefulWidget{

  final List<Location> locations;
  final Widget child;
  
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
  int count;

  @override
  Widget build(BuildContext context) {
    print("Inherited Widget is initialized");

    count = 1;

    return new InheritedStateContainer(
      this,       //data passed down
      widget.child //child
    );
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