import 'package:flutter/material.dart';
import './utils/container.dart';
import './view/device_presenter.dart';
import './data/model/location.dart';
import './data/model/device.dart';
import './utils/toast.dart';

class AddDevicePage extends StatefulWidget{
  static const String routeName = "/add-device";

  @override
  AddDevicePageContainerState createState() => new AddDevicePageContainerState();
}

class AddDevicePageContainerState extends State<AddDevicePage> implements AddDevicePageContract{
  var container;
  Location location;
  String deviceType = "";

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final portController = TextEditingController();

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
      descController.text = "";
      portController.text = "";
    }

  void addNewDevice(){
    if(nameController.text == ""){
      Toaster.create("Name shouldn't be blank!");
      return;
    }

    if(portController.text == ""){
      Toaster.create("Port shouldn't be blank!");
      return;
    }

    if(deviceType == ""){
      Toaster.create("You have to choose is it input or output!");
    }

    Device newDevice;
    if(descController.text != '')
      newDevice = new Device(name: nameController.text, description: descController.text, 
        port: int.parse(portController.text), type: deviceType);
    else
      newDevice = new Device(name: nameController.text,
                             port: int.parse(portController.text), 
                             type: deviceType,
                             locationId: location.uid);

    presenter.saveDeviceOnLocation(newDevice, location);
  }

  void _radioValueChanged(String type){
    setState(() {
      this.deviceType = type; 
    });
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
            onPressed: addNewDevice,
          )
        ],
      ),
      body: new Container(
        margin: EdgeInsets.all(0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            ),
            new ListTile(
              leading: new Icon(Icons.description),
              title: new TextField(
                controller: descController,
                autocorrect: false,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Description'
                  ),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.lightbulb_outline),
              title: new TextField(
                keyboardType: TextInputType.number,
                controller: portController,
                autocorrect: false,
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Port Number'
                  ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: this.deviceType == "input",
                        groupValue: true,
                        onChanged: (bool val){_radioValueChanged("input");},
                      ),
                      new Text(
                        "Input",
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){_radioValueChanged("input");},
                ),
                new FlatButton(
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: this.deviceType == "output",
                        groupValue: true,
                        onChanged: (bool val){_radioValueChanged("output");},
                      ),
                      new Text(
                        "Output",
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){_radioValueChanged("output");},
                )
              ],
            ) 
          ],
        ),
      ),
    );
  }
}