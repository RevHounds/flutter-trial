import 'package:flutter/material.dart';
import '../data/model/location.dart';
import '../utils/container.dart';
import '../location_detail.dart';

class LocationCard extends StatelessWidget{
  final Location _location;
  var container;

  LocationCard(this._location);

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    return new Card(
      child: new FlatButton(
        onPressed: (){_gotoLocationDetail(context, _location);},
        child: new Column(
          children: <Widget>[
            new Image.network(
                _location.picture,
                scale: 0.8,
                height: 150.0,
                width: 150.0),
            new Text(_location.name)
          ]
        )
      )
    );
  }

  void _gotoLocationDetail(BuildContext context, Location location){
    print(location.uid);
    container.onFocusLocation = location;
    
    Navigator.push(
      context, 
      new MaterialPageRoute(
        settings: new RouteSettings(name: LocationDetail.routeName),
        builder: 
          (context){
            return new LocationDetail(location.uid);
          }
      )
    );
  }
}