import 'package:flutter/material.dart';
import 'data/model/location.dart';
import './utils/container.dart';
import './view/location_presenter.dart';

final nameController = TextEditingController();
final addressController = TextEditingController();

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

  @override
  void initState(){
    super.initState();
    nameController.text = "";
    addressController.text = "";

    presenter = new AddLocationPresenter(this);
  } 

  @override
  void onSaveLocation(List<Location> locations) {
    container.locations = locations;
    Navigator.pop(context);
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
            onPressed: _saveLocation)
        ],
          
      ),
      body: new AddLocationForm(),
    );
  }

  void _saveLocation(){
    String name = nameController.text;
    String address = addressController.text;
    
    LocationAddView newLocationView = new LocationAddView(name, address);
    
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
                  controller: addressController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Address'
                  ),
                )
            )
          ],
        ),
      );
  }
  
}