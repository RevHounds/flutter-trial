import 'dart:async';
import 'package:flutter/material.dart';
import 'data/model/location.dart';
import 'data/model/device.dart';
import 'view/location_presenter.dart';
import 'utils/container.dart';
import './add_device_page.dart';
import './widgets/loading_screen.dart';
import 'device_detail.dart';

class LocationDetail extends StatefulWidget{
  static String routeName = '/location_detail';
  String locationUID;

  LocationDetail(this.locationUID);

  @override
  LocationDetailState createState() => new LocationDetailState(locationUID);
}

class LocationDetailState extends State<LocationDetail> implements LocationDetailAppBarContract{
  Location location;
  var container;
  String locationUID;
  LocationAppBarPresenter presenter;  
  bool closePage = false;

  LocationDetailState(this.locationUID){
    presenter = new LocationAppBarPresenter(this);
  }

  @override
  void onDeleteLocation(Location location){
    container.deleteLocation(location);
    Navigator.of(context).pop();
  }

  Future<Null> _neverSatisfied() async {
    String locationName = location.name;
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete Location'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Are you sure you wanted to delete $locationName?")
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
                presenter.deleteLocation(locationUID);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteLocation(){
    _neverSatisfied();
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.location = container.findLocationByUID(locationUID);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(location.name),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: deleteLocation,
            )
        ],
      ),
      body: new DeviceList(location.uid),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){
          addDeviceTo(location);
        },
      ),
    );
  }

  void addDeviceTo(Location location){
    container.onFocusLocation = location;

    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: const RouteSettings(name: AddDevicePage.routeName),
        builder: (context){
          return new AddDevicePage();
        }
      )
    );
  }
}

class DeviceList extends StatefulWidget{
  final String locationUID;

  DeviceList(this.locationUID);

  @override
  DeviceListState createState() => new DeviceListState();
}

class DeviceListState extends State<DeviceList> implements LocationDetailContract{
  var container;
  bool isSearching;
  Location location;
  LocationDetailPresenter presenter;
  List<Device> devices;

  DeviceListState(){
    presenter = new LocationDetailPresenter(this);
  }

  @override
  void onLoadLocation(Location location){
    container.onFocusLocation = location;
    isSearching = false;
    
    String locationName = location.name;
    print("location name: $locationName");

    setState(() {
      location = container.onFocusLocation;
    });
  }

  @override
  void onChangeState(Location location){
    for(int i = 0; i<container.locations.length; i++){
      if(container.locations[i].isEqualWithLocation(location)){
        container.locations[i] = location;
      }
    }
    setState(() {
      this.devices = location.devices;      
    });
  }

  @override
  void initState() {
    super.initState();
    isSearching = true;
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    location = container.onFocusLocation;
    devices = location.devices;
    
    var page;
    var body;

    if(isSearching){
      presenter.loadLocationByUID(location);
      body = new LoadingScreen();
    } else{
      body = buildDeviceList(devices.length);
    }

    var curators = new List<Widget>();

    curators.add(buildHeader());
    curators.addAll(buildDeviceList(devices.length).toList());
    curators.add(buildFooter());

    page = new ListView(
      children: curators
    );
    return page;
  }

  int getDeviceOn(){
    int count = 0;
    for(Device device in devices){
      if(device.status)
        count++;
    }
    return count;
  }

  Widget buildHeader(){
    int device_on = 0, device_off = 0, device_total = 0;
    
    device_on = getDeviceOn();
    device_total = devices.length;
    device_off = device_total - device_on;

    return new Card(
      child: 
      new Row(
        children: <Widget>[
          new Padding(
            child: new Icon(
              Icons.home,
              size: 100.0,
            ),
            padding: EdgeInsets.all(25.0),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Active Device: $device_on", 
                textScaleFactor: 1.3,
                textAlign: TextAlign.left,
              ),
              new Divider(
                color: Colors.black,
              ),
              new Text(
                "Inactive Device: $device_off", 
                textScaleFactor: 1.3,
                textAlign: TextAlign.left,
              ),
              new Divider(
                color: Colors.black,
              ),
              new Text(
                "Total Device: $device_total",                 
                textScaleFactor: 1.3,
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }


  Widget buildFooter(){
    return new Padding(
      padding: new EdgeInsets.all(40.0),
      child: new Text(
        "To add new device,\nclick the add button on the right!", 
        textAlign: TextAlign.center
        ),
    );
  }

  List<Widget> buildDeviceList(int length){
    List<Widget> list = new List<Widget>();
    for(int index = 0; index<length; index++){
      list.add(
        new Card(
          elevation: 1.5,
          child: new FlatButton(
            onPressed: (){
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context){
                    print(devices[index].name);
                    return new DeviceDetailPage(devices[index]);
                  }
                )
              );
            },
            child:
              new ListTile(
                leading: new Icon(Icons.lightbulb_outline),
                title: new Text(devices[index].name),
                trailing: new Switch(
                  value: devices[index].status,
                  onChanged: (value){
                    presenter.changeState(location, devices[index]);
                  },
                ),
                subtitle: new Text(devices[index].description),
              ),
          ),
        )
      );
    }
    return list;
  }
}