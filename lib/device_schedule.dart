import 'package:flutter/material.dart';
import 'view/schedule_presenter.dart';
import 'widgets/loading_screen.dart';
import 'utils/container.dart';
import 'data/model/device.dart';
import 'data/model/schedule.dart';
import 'data/model/location.dart';
import './widgets/schedule_card.dart';
import 'add_schedule.dart';

class DeviceDetailPage extends StatefulWidget{
  static const String routeName = "/device-detail";

  @override
  State<DeviceDetailPage> createState() => new DeviceDetailPageState();
}

class DeviceDetailPageState extends State<DeviceDetailPage> implements DeviceDetailSchedulePageContract{
  var container;
  Device device;
  List<Schedule> schedules;
  ListView scheduleView = new ListView();
  DeviceDetailPagePresenter presenter;
  bool isSearching;

  DeviceDetailPageState(){
    presenter = new DeviceDetailPagePresenter(this);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    this.device = container.onFocusDevice; 
    this.schedules = device.schedules;

    var body;

    if(isSearching){
      body = new LoadingScreen();
      presenter.loadSchedules(this.device);
    } else{
      body = new ListView(
        children: _generateScheduleList(schedules)
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
        onPressed: _addSchedule
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    isSearching = true;
  }

  @override
  void onSchedulesLoaded(List<Schedule> newSchedules){
    setState(() {
      device.schedules = newSchedules;
      container.onFocusDevice = device;
      this.isSearching = false;
    });
  }

  @override
  void onScheduleAdded(List<Location> locations){
    container.locataions = locations;
    setState(() {
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

  List<Widget> _generateScheduleList(List<Schedule> schedules){
    List<ScheduleCard> cards = new List<ScheduleCard>();

    for(Schedule schedule in schedules){
      cards.add(new ScheduleCard(schedule, device));
    }

    return cards;
  }

  void _addSchedule(){
    Schedule newSchedule = new Schedule();
    container.onFocusSchedule = newSchedule;
    this.device = container.onFocusDevice;

    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new AddSchedulePage();
        }
      )
    );
  }

  void _deleteDevice(){
    print("deleting device");
    popUpDeleteDevice();
  }

  Future<Null> popUpDeleteDevice() async {
    String deviceName = this.device.name;
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
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
}