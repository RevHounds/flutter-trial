import 'package:flutter/material.dart';
import './utils/container.dart';
import './view/device_presenter.dart';
import './data/model/location.dart';


class AddDevicePage extends StatefulWidget{
  static const String routeName = "/add-device";

  @override
  AddDevicePageContainerState createState() => new AddDevicePageContainerState();
}

class AddDevicePageContainerState extends State<AddDevicePage> implements AddDevicePageContract{
  var container;
  Location location;

  final nameController = TextEditingController();

  AddDevicePresenter presenter;

  AddDevicePageContainerState(){
    presenter = new AddDevicePresenter(this);
  }

  @override
  void onAddDevice(List<Location> locations){
    container.locations = locations;
    Navigator.pop(context);
  }

  @override
  void initState() {
      super.initState();
      nameController.text = "";
    }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    location = container.onFocusLocation;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Device"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done),
            onPressed: (){
              Device newDevice = new Device(name: nameController.text);
              presenter.saveDeviceOnLocation(newDevice, location);
            },
          )
        ],
      ),
      body: new Form(
        child: new ListView(
          padding: new EdgeInsets.all(8.0),
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.lightbulb_outline),
              title:  new TextField(
                  controller: nameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Name'
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}