import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'view/location_presenter.dart';
import 'data/model/location.dart';
import 'utils/container.dart';
import './add_location.dart';
import 'location_detail.dart';
import 'login.dart';
import 'register.dart';
import './view/app_presenter.dart';
import 'widgets/location_card.dart';

class MainMenu extends StatefulWidget{
  @override
  State<MainMenu> createState() => new MainMenuState();
}

class MainMenuState extends State<MainMenu> implements LogoutContract, LocationListContract{
  MainMenuPresenter mainMenuPresenter;
  LocationListPresenter locationListPresenter;
  List<Location> locations;
  var container;
  bool isSearching;

  MainMenuState(){
    isSearching = true;
    mainMenuPresenter = new MainMenuPresenter(this);
    locationListPresenter = new LocationListPresenter(this);
    init();
  }

  void init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", true);
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
      locationListPresenter.loadLocations(container.user);
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
      body: widget,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){_gotoAddLocationPage(context);
        },
      ),
    );
  }

  @override
  void onLogout(){
    setState(() {
      print("MOVING ON");
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context){
            return new LoginPage();
          }
        ));
      print("MOVING OFF");
    });
  }
  

  Future<Null> _logOutPopUp() async {
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
                  print(state.toString());
                  mainMenuPresenter.logout();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
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

  void _logout(){
    _logOutPopUp();
  }

  void refreshData(){
    setState(() {
      locations = new List<Location>();
      isSearching = true;
    });
    locationListPresenter.loadLocations(container.user);
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