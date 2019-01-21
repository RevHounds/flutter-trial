import 'package:flutter/material.dart';
import 'view/schedule_presenter.dart';
import 'utils/container.dart';
import 'data/model/device.dart';
import 'data/model/schedule.dart';
import 'data/model/location.dart';
import 'schedule_detail.dart';

class DeviceDetailPage extends StatefulWidget{
  static const String routeName = "/device-detail";
  Device device; 

  DeviceDetailPage(this.device){
    print("loaded device detail page, loading " + device.name);
  }

  @override
  State<DeviceDetailPage> createState() => new DeviceDetailPageState(this.device);
}

class DeviceDetailPageState extends State<DeviceDetailPage> implements DeviceDetailPageContract{
  var container;
  Device device;
  List<Schedule> schedules;
  ListView scheduleView = new ListView();
  DeviceDetailPagePresenter presenter;

  DeviceDetailPageState(this.device){
    schedules = new List<Schedule>();
    presenter = new DeviceDetailPagePresenter(this);
    presenter.loadSchedules(device);
  }

  @override
  void onSchedulesLoaded(List<Schedule> newSchedules){
    setState(() {
      this.schedules = newSchedules;      
    });
  }

  @override
  void onScheduleAdded(List<Location> locations){
    container.locataions = locations;
    setState(() {
    });
  }

  @override
  void initState() {
      super.initState();
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
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new ScheduleDetailPage(this.device);
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
  
  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

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
      body: new ListView(
        children: _generateScheduleList(schedules)
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: _addSchedule
      ),
    );
  }
}

class ScheduleCard extends StatefulWidget{
  Schedule schedule;
  Device device;
  ScheduleCard(this.schedule, this.device);
  @override
  State<ScheduleCard> createState() => new ScheduleCardState(this.schedule, this.device);
}

class ScheduleCardState extends State<ScheduleCard> implements ScheduleCardContract{
  Schedule schedule;
  Device device;
  ScheduleCardPresenter presenter;
  var container;

  ScheduleCardState(this.schedule, this.device){
    this.presenter = new ScheduleCardPresenter(this);
  }

  @override
  void onScheduleUpdated(List<Location> locations){
    container.locations = locations;
    setState(() {
    });
  }

  void _onStatusChanged(bool value){
    print("something just happened");
    setState(() {
      schedule.status = !schedule.status;
      presenter.saveSchedule(schedule, device);
    });
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    return new Card(
      child: new FlatButton(
        child: new ListTile(
          title: new Text(schedule.start + " - " + schedule.command),
          subtitle: new Text(schedule.repeat),
          trailing: new Switch(
            activeColor: Colors.blue,
            value: schedule.status,
            onChanged: _onStatusChanged,
          ),
        ),
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context){
                container.onFocusSchedule = schedule;
                return new ScheduleDetailPage(device);
              }
            )
          );
        },
      ),
    );  
  }
}