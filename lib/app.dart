import 'package:flutter/material.dart';
import 'view/location_presenter.dart';
import 'data/model/location.dart';
import 'utils/container.dart';
import './add_location_page.dart';
import 'location_detail.dart';
import 'login.dart';

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

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Main Menu"),
      ),
      body: new LocationList(),
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
  LocationListState createState() => new LocationListState();
}

class LocationListState extends State<LocationList> implements LocationListContract{
  List<Location> locations;
  LocationListPresenter presenter;
  bool isSearching;
  var container;


  LocationListState(){
    isSearching = true;
    presenter = new LocationListPresenter(this);

    print("Presenter initialized");
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
    print("Error Load Location");
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

    print("Done Called");

    var widget;

    if(isSearching){
      print("Went in");
      presenter.loadLocations();


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