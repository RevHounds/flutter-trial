import 'package:flutter/material.dart';
import 'data/model/location.dart';
import 'view/location_presenter.dart';
import 'utils/toast.dart';
import 'utils/container.dart';
import 'app.dart';


class PairingStatusPage extends StatefulWidget{
  static const String routeName = "/pairing-status";
  Location location;
  PairingStatusPage(this.location){
    print("Right here buddy");
    print("Location id: " + this.location.uid);
  }
  
  @override
  State<PairingStatusPage> createState() => new PairingStatusPageState(this.location);
}

class PairingStatusPageState extends State<PairingStatusPage> implements LocationPairingStatusContract{
  Location location;
  LocationPairingPresenter presenter;
  var container;

  PairingStatusPageState(this.location){
    print("anake yo wes mari");
    this.presenter = new LocationPairingPresenter(this);
  }

  @override
  void onPairingFinished(Location location){
    print("Location name: " + location.name);

    List<Location> conLoc = container.locations;

    for(Location loc in conLoc){
      if(loc.uid == location.uid){
        location.status = "owned";
        break;
      }
    }

    container.locations = conLoc;

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
              child: new Text("You have been sent an email verification, open the email and go to the given link to verify you are the one adding the location",
                              textAlign: TextAlign.center),
              padding: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 20.0),
            ),
            new RaisedButton(
              child: new Text("I have verified!"),
              onPressed: checkPairingStatus,
            )
          ],
        ),
      ),
    );
  }
}