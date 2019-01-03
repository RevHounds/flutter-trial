import 'package:flutter/material.dart';
import 'data/model/location.dart';
import './utils/container.dart';
import './view/location_presenter.dart';
import './utils/toast.dart';
import './pairing_status.dart';

final nameController = TextEditingController();
final locationIdController = TextEditingController();

class AddLocationPage extends StatelessWidget{
  static const String routeName = '/add-location';
  var locationInheritedWidget;

  @override
  Widget build(BuildContext context){
    return new AddLocationContainer();
  }
}

class AddLocationContainer extends StatefulWidget{
  @override
  State<AddLocationContainer> createState() => new AddLocationContainerState();
}

class AddLocationContainerState extends State<AddLocationContainer> implements AddLocationContract{
  var container;
  AddLocationPresenter presenter;
  String classLocationId;

  @override
  void initState(){
    super.initState();
    nameController.text = "";
    locationIdController.text = "";

    presenter = new AddLocationPresenter(this);
  } 

  @override
  void onSaveLocation(List<Location> locations) {
    container.locations = locations;
    print("we have come this far");
    Location loc;
    if (locations.length > 0){
      loc = locations[locations.length - 1];
      print("location len: " + locations.length.toString());
    } else{
      loc = new Location(classLocationId, "ngyah", "pict");
      print("I choose another path altogether");
    }

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context){
          return new PairingStatusPage(loc);
        }
      )
    );
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add new Location'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done),
            onPressed: _saveLocation
          )
        ],  
      ),
      body: new AddLocationForm(),
    );
  }

  void _saveLocation(){
    String name = nameController.text;
    String locationId = locationIdController.text;

    if(nameController.text == ""){
      Toaster.create("Name shouldn't be blank");
      return;
    }

    if(locationIdController.text == ""){
      Toaster.create("Address shouldn't be blank");
      return;
    }
    
    classLocationId = locationId;
    LocationAddView newLocationView = new LocationAddView(locationId, name);
    
    presenter.saveLocation(newLocationView);
  }
}

class AddLocationForm extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Form(
        child: new ListView(
          padding: new EdgeInsets.all(8.0),
          children: <Widget>[
            new ListTile(
                leading: new Icon(Icons.person),
                title:  new TextField(
                  controller: nameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Name'
                  ),
                ),
                trailing: new Icon(Icons.add_a_photo),
            ),
            new ListTile(
                leading: new Icon(Icons.place),
                title: new TextField(
                  controller: locationIdController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Location ID'
                  ),
                )
            )
          ],
        ),
      );
  }
  
}