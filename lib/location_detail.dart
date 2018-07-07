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
    
    int device_on = 0, device_off = 0, device_total = 0;

    var page;
    var header;
    var body;

    if(isSearching){
      presenter.loadLocationByUID(location.uid);
      body = new Center(
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator()
        )
      );      
    } else if(devices.isNotEmpty){

    }

    device_off = device_total - device_on;

    page = new ListView(
      children: buildDeviceList(devices.length)
    );

    return page;

  }

  Widget buildHeader(){
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
            children: <Widget>[
              new Text("text 1", ),
              new Divider(
                color: Colors.grey,
              ),
              new Text("text 2"),
              new Divider(
                color: Colors.grey,
              ),
              new Text("text 3"),
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
    list.add(buildHeader());
    for(int index = 0; index<length; index++){
      list.add(
        new Card(
          elevation: 1.5,
          child: new Column(
            children: <Widget>[
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
            ],
          ),
        )
      );
    }
    list.add(buildFooter());
    return list;
  }
}