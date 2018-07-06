import 'package:flutter/material.dart';
import 'data/model/location.dart';
import 'view/location_presenter.dart';
import 'utils/container.dart';
import './add_device_page.dart';

class LocationDetail extends StatefulWidget{
  static String routeName = '/location_detail';
  String locationUID;

  LocationDetail(this.locationUID);

  @override
  LocationDetailState createState() => new LocationDetailState(locationUID);
}

class LocationDetailState extends State<LocationDetail>{
  Location location;
  var container;
  String locationUID;

  LocationDetailState(this.locationUID);

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.location = container.findLocationByUID(locationUID);
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(location.name),
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

    var widget;

    if(isSearching){
      presenter.loadLocationByUID(location.uid);
      widget = new Center(
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator()
        )
      );      
    } else if(devices.isNotEmpty){
      int length = devices.length;
      print("number of devices: $length");
      widget = new ListView.builder(
        itemBuilder: (BuildContext context, int index){
                        return new ListTile(
                          leading: new Icon(Icons.lightbulb_outline),
                          title: new Text(devices[index].name),
                          trailing: new Switch(
                            value: devices[index].status,
                            onChanged: (value){
                              presenter.changeState(location, devices[index]);
                            },
                          ),
                        );
                      }, 
        itemCount: devices.length,
      );
    } else{
      widget = new Center(
        child: new Text("There is nothing to show"),
      );
    }
    return widget;
  }
}