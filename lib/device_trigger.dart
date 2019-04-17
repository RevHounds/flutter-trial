import 'package:flutter/material.dart';
import 'view/schedule_presenter.dart';
import 'widgets/loading_screen.dart';
import 'utils/container.dart';
import 'data/model/device.dart';
import 'add_trigger.dart';
import 'data/model/location.dart';
import 'data/model/trigger.dart';
import './widgets/trigger_card.dart';

class DeviceTriggerPage extends StatefulWidget{
  static const String routeName = "/device-trigger";

  @override
  State<DeviceTriggerPage> createState() => new DeviceTriggerPageState();
}

class DeviceTriggerPageState extends State<DeviceTriggerPage> implements DeviceDetailTriggerPageContract{
  var container;
  Device device;
  List<Trigger> triggers;
  ListView triggerView = new ListView();
  DeviceTriggerPagePresenter presenter;
  bool isSearching;

  DeviceTriggerPageState(){
    presenter = new DeviceTriggerPagePresenter(this);
  }

  @override
  void initState(){
    super.initState();
    isSearching = true;
  }

  @override
  void onTriggersLoaded(List<Trigger> newTrigger){
    setState(() {
      device.triggers = newTrigger;
      container.onFocusDevice = device;
      this.isSearching = false;
    });
  }

  @override
  void onTriggerAdded(List<Location> locations){
    setState(() {
    container.locataions = locations;
    });
  }

  @override
  void onDeviceDeleted(List<Location> locations){
    container.locations = locations;
    setState(() {
      Location currentLocation;
      for(Location location in locations){
        if(location.isEqualWithUID(device.locationId)){
          currentLocation = location;
          break;
        }
      }
      currentLocation.devices.removeWhere(
        (currentDevice) => currentDevice.uid == this.device.uid        
      );
      container.devices = currentLocation.devices;
      Navigator.of(context).pop();
    });
  }

  List<Widget> _generateTriggerList(List<Trigger> triggers){
    List<TriggerCard> cards = new List<TriggerCard>();

    for(Trigger trigger in triggers){
      cards.add(new TriggerCard(trigger, device));
    }

    return cards;
  }

  void _addTriggers(){
    Trigger newTrigger = new Trigger(locationId: device.locationId,
      inputPort: device.port, outputPort: -1);

    container.onFocusTrigger = newTrigger;
    this.device = container.onFocusDevice;

    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new AddTriggerPage();
        }
      )
    );
  }

  Future<Null> popUpDeleteDevice() async {
    String deviceName = this.device.name;
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete Device'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Are you sure you wanted to delete $deviceName?")
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton( 
              child: new Text("Delete"),
              onPressed: () {
                presenter.deleteDevice(this.device);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  void _deleteDevice(){
    print("deleting device");
    popUpDeleteDevice();
  }
  
  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    this.device = container.onFocusDevice; 
    this.triggers = device.triggers;

    var body;

    if(isSearching){
      body = new LoadingScreen();
      presenter.loadTriggers(this.device);
    } else{
      body = new ListView(
        children: _generateTriggerList(triggers)
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(device.name + ' Detail'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: _deleteDevice,
            )
        ],
      ),
      body: body,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: _addTriggers
      ),
    );
  }
}

