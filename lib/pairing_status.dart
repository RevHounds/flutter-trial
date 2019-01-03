import 'package:flutter/material.dart';
import 'data/model/location.dart';
import 'view/location_presenter.dart';
import 'utils/toast.dart';
import 'utils/container.dart';
import 'app.dart';

class PairingStatusPage extends StatelessWidget{
  Location location;
  static const String routeName = "/pairing-status";

  PairingStatusPage(this.location){
    print("gaero be e");
  }

  Widget build(BuildContext context){
    return new PairingStatusContainer(this.location);
  }
}


class PairingStatusContainer extends StatefulWidget{
  Location location;
  PairingStatusContainer(this.location){
    print("Right here buddy");
    print("Location id: " + this.location.uid);
  }
  
  @override
  State<PairingStatusContainer> createState() => new PairingStatusContainerState(this.location);
}

class PairingStatusContainerState extends State<PairingStatusContainer> implements LocationPairingStatusContract{
  Location location;
  LocationPairingPresenter presenter;
  var container;

  PairingStatusContainerState(this.location){
    print("anake yo wes mari");
    this.presenter = new LocationPairingPresenter(this);
  }

  @override
  void onPairingFinished(Location location){
    print("Location name: " + location.name);

    List<Location> conLoc = container.locations;

    for(Location loc in conLoc){
      if(loc.uid == location.uid){
        loc = location;
        break;
      }
    }

    Navigator.of(context).pop();
  }

  @override
  void onPairingNotFinished(Location location){
    Toaster.create("You have not finished the pairing process!");
  }

  @override
  void initState() {  
    super.initState();
  }

  void checkPairingStatus(){
    presenter.checkStatus(location);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pairing Status"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Padding(
              child: new Text("You have to press a button which is currently on right now on your raspberry, then click the button below",
                              textAlign: TextAlign.center),
              padding: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 20.0),
            ),
            new RaisedButton(
              child: new Text("I have pressed the button!"),
              onPressed: checkPairingStatus,
            )
          ],
        ),
      ),
    );
  }
}