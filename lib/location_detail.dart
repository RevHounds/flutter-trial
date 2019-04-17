import 'dart:async';
import 'package:flutter/material.dart';
import 'data/model/location.dart';
import 'data/model/device.dart';
import 'view/location_presenter.dart';
import 'utils/container.dart';
import './add_device.dart';
import './widgets/loading_screen.dart';
import 'widgets/input_device_tile.dart';
import 'widgets/output_device_tile.dart';

class LocationDetail extends StatefulWidget{
  static String routeName = '/location_detail';
  String locationUID;

  LocationDetail(this.locationUID);

  @override
  LocationDetailState createState() => new LocationDetailState(locationUID);
}

class LocationDetailState extends State<LocationDetail> implements LocationDetailContract{
  Location location;
  var container;
  String locationUID;
  List<Device> devices;
  LocationDetailPresenter presenter;  
  bool closePage = false;
  List<Widget> locationDetailPage;
  bool isSearching;

  LocationDetailState(this.locationUID){
    presenter = new LocationDetailPresenter(this);
    isSearching = true;
    this.devices = new List<Device>();
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.location = container.onFocusLocation;

    var body;

    locationDetailPage = new List<Widget>();
    locationDetailPage.add(buildHeader());
    
    if(isSearching){
      presenter.loadLocationDevices(location);
      body = new LoadingScreen();
      locationDetailPage.add(body);
    } else{
      body = new List<Widget>();  
      body.addAll(buildInputDeviceList());
      body.addAll(buildOutputDeviceList());
      locationDetailPage.addAll(body);
    }    

    locationDetailPage.add(buildFooter());

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
      body: new ListView(
        children: locationDetailPage,
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){
          addDeviceTo(location);
        },
      ),
    );
  }

  @override
  void onLoadLocation(Location location) {
    setState(() {
      this.location = location;
      this.devices = location.devices;
      this.isSearching = false;
      container.onFocusLocation = location;
    });
  }

  @override
  void onDeleteLocation(List<Location> locations){
    setState(() {
      locations.removeWhere((location) => location.isEqualWithLocation(this.location));
      container.locations = locations;
    });
    Navigator.of(context).pop();
  }

  Future<Null> popUpDeleteLocation() async {
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
    popUpDeleteLocation();
  }

  int getDeviceOnStatusCount(){
    int count = 0;
    if(devices.length == 0)
      return count;

    for(Device device in devices){
      if(device.status)
        count++;
    }
    return count;
  }

  Widget buildHeader(){
    int device_on = 0, device_off = 0, device_total = 0;
    
    device_on = getDeviceOnStatusCount();
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

    List<Widget> inputList = buildInputDeviceList();
    List<Widget> outputList = buildOutputDeviceList();
   

    list = new List.from(inputList)..addAll(outputList);

    return list;
  }


  List<Widget> buildInputDeviceList(){
    List<Widget> inputList = new List<Widget>();

    int len = devices.length;
    for(int i = 0; i< len; i++){
      if(devices[i].type == "output") continue;
      inputList.add(new InputDeviceTile(devices[i]));
    }
    return inputList;
  }

  List<Widget> buildOutputDeviceList(){
    List<Widget> outputList = new List<Widget>();
    List<Device> outputs = new List();
    int len = devices.length;
    for(int i = 0; i< len; i++){
      if(devices[i].type == "input") continue;
      outputs.add(devices[i]);
      outputList.add(new OutputDeviceTile(devices[i]));
    }
    return outputList;
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