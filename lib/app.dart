import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'view/location_presenter.dart';
import 'data/model/location.dart';
import 'data/model/device.dart';
import 'data/model/schedule.dart';
import 'utils/container.dart';
import './add_location_page.dart';
import 'location_detail.dart';
import 'login.dart';
import 'device_detail.dart';
import 'schedule_detail.dart';
import './view/app_presenter.dart';

class Myapp extends StatelessWidget{
  var container;
  var homePage;

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    homePage = new LoginPage();

    return new MaterialApp(
      title: "Smart Home",
      home: homePage
    );
  }
}

class MainMenu extends StatefulWidget{
  @override
  State<MainMenu> createState() => new MainMenuState();
}

class MainMenuState extends State<MainMenu> implements LogoutContract{
  MainMenuPresenter presenter;
  LocationList locationList = new LocationList();
  var container;

  void init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", true);
  }    

  @override
  void onLogout(){
    print("lagi logout");
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context){
          print("sampe sini lho cok udahan");
          return new LoginPage();
        }
      ));
  }
  
  MainMenuState(){
    presenter = new MainMenuPresenter(this);
    init();
  }

  Future<Null> _neverSatisfied() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Log Out'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Are you sure you wanted to log out?")
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
              child: new Text("Log out"),
              onPressed: () {
                pref.setBool("isLoggedIn", false).then((state){
                  print("logged off");
                  presenter.logout();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(){
    _neverSatisfied();
  }

  void refreshData(){
    locationList.presenter.loadLocations(container.user);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Main Menu"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshData,
          ),
          new IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: _logout,
          )
        ],
      ),
      body: locationList,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){_gotoAddLocationPage(context);
        },
      ),
    );
  }

  void _gotoAddLocationPage(BuildContext context){
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: const RouteSettings(name: AddLocationPage.routeName),
        builder: (context){
          return new AddLocationPage();
        }
      )
    );
  }
}

class LocationList extends StatefulWidget{
  @override
  LocationListPresenter presenter;
  LocationListState createState() => new LocationListState(this.presenter);
}

class LocationListState extends State<LocationList> implements LocationListContract{
  LocationListPresenter presenter;
  List<Location> locations;
  bool isSearching;
  var container;

  LocationListState(this.presenter){
    isSearching = true;
    presenter = new LocationListPresenter(this);
  }

  @override
  void onLoadLocationComplete(List<Location> locations){
    setState(() {
      int n  = locations.length;
      print("Found something, count: $n");
      container.locations = locations;
      isSearching = false;
    });
  }

  @override
  void onErrorLoadLocation(){
    setState((){
      container.locations = List<Location>();
      isSearching = false;
      print("no location found");
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
    locations = container.locations;

    if(locations != null)
      locations.removeWhere((location) => location.status == "pending");

    print("Done Called");

    var widget;

    if(isSearching){
      presenter.loadLocations(container.user);
      print("Went in");

      widget = new Center(
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator()
        )
      );
    } else{
      int n = locations.length;
      print("Count: $n");

      widget = new GridView.count(
        crossAxisCount: 2,
        padding: new EdgeInsets.all(4.0),
        children: 
          locations.map((location) => 
              new LocationCard(location)).toList(),
      );
    }

    return widget;
  }
}


class LocationCard extends StatelessWidget{
  final Location _location;

  @override
  Widget build(BuildContext context){
    return new Card(
      child: new FlatButton(
        onPressed: (){_gotoLocationDetail(context, _location);},
        child: new Column(
          children: <Widget>[
            new Image.network(
                _location.picture,
                scale: 0.8,
                height: 150.0,
                width: 150.0),
            new Text(_location.name)
          ]
        )
      )
    );
  }

  LocationCard(this._location);

  void _gotoLocationDetail(BuildContext context, Location location){
    print(location.uid);
    Navigator.push(
      context, 
      new MaterialPageRoute(
        settings: new RouteSettings(name: LocationDetail.routeName),
        builder: 
          (context){
            return new LocationDetail(location.uid);
          }
      )
    );
  }
}