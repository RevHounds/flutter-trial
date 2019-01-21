import 'package:flutter/material.dart';
import './view/schedule_presenter.dart';
import './data/model/device.dart';
import './data/model/schedule.dart';
import './data/model/location.dart';
import './utils/container.dart';

class addschedulePage extends StatefulWidget{
  static const String routeName = "/schedule-detail";
  Device device;
  addschedulePage(this.device);

  @override
  State<addschedulePage> createState() => new addschedulePageState(this.device);

}
class addschedulePageState extends State<addschedulePage> implements AddSchedulePageContract{
  Device device;
  Schedule schedule;
  AddSchedulePagePresenter presenter;
  var container;
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  bool isLoading = true;

  addschedulePageState(this.device);
  
  @override
  void onScheduleSaved(List<Location> locations){
    container.locations = locations;
    setState(() {      
    }); 
  }

  @override
  void onScheduleModified(Schedule schedule){
    this.schedule = schedule;
  }

  @override
  void onScheduleDeleted(List<Location> locations){
    container.locations = locations;
    Navigator.of(context).pop();
  }

  Future<Null> popUpDeleteSchedule() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete Schedule'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Are you sure you wanted to delete this schedule?")
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
                presenter.deleteSchedule(this.schedule, this.device);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSchedule(){
    popUpDeleteSchedule();
  }

  void getSchedule(){
    this.schedule = container.onFocusSchedule;
    setState(() {});
  }

  void _cancelModify(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    
    if(this.schedule == null){
      getSchedule();
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.device.name + '\'s Schedule'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: _deleteSchedule,
          )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new TimeCards("Start", this.schedule.start),
          new ListTile(
            contentPadding: new EdgeInsets.all(0.0),
            leading: new Checkbox(
              value: false,
            ),
            title: new Text("Ranged schedule"),
          ),
          new TimeCards("End", this.schedule.end),
          new Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 15.0),
                    child: new Text(
                      "Repeat",
                      style: new TextStyle(
                        fontSize: 18
                      )
                    ),
                  ),
                  new ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: days.map(
                                (day)=> new DayButton(day, this.schedule)
                              ).toList()
                  )
                ],
              )
            )
          ),
          new Padding(padding: EdgeInsets.all(25),),
          new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new MaterialButton(
                child: new Text(
                  "Cancel",
                  style: new TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                  ),
                ),
                color: Colors.white,
                height: 40,
                minWidth: 120.0,
                onPressed: (){
                  _cancelModify();
                },
              ),
              new MaterialButton(
                child: new Text(
                  "Save",
                  style: new TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
                color: Colors.blue,
                height: 40,
                minWidth: 120.0,
                onPressed: (){
                  presenter.saveSchedule(this.schedule, this.device);
                },
              ),
            ],
          )
        ],
      )
    );
  }
}

class DayButton extends StatefulWidget{
  final String day;
  final Schedule schedule;
  DayButton(this.day, this.schedule);

  @override
  State<DayButton> createState() => new DayButtonState(this.day, this.schedule);
}

class DayButtonState extends State<DayButton> implements DayButtonContract{
  final String day;
  String shortDay;
  bool currentState;
  Schedule schedule;
  DayButtonPresenter presenter;

  DayButtonState(this.day, this.schedule){
    shortDay = day.substring(0,2);
    this.currentState = schedule.repeatDay[day] || false;
    this.presenter = new DayButtonPresenter(this);
  }

  @override
  void onRepeatPressed(bool value){
    this.currentState = value;      
    schedule.repeatDay[day] = value;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context){
    return new FlatButton(
      color: currentState ? Colors.blue : Colors.white,
      child: new Text(
        shortDay,
        style: new TextStyle(
          fontSize: 18,
          color: currentState ? Colors.white : Colors.blue
        )  
      ),
      shape: new CircleBorder(),
      onPressed: (){
        presenter.selectDay(this.day, this.schedule);
        setState(() {
          this.currentState = !this.currentState;          
        });
      },
    );
  }
}

class TimeCards extends StatefulWidget{
  final String title, time;

  TimeCards(this.title, this.time);
  
  @override
  State<TimeCards> createState() => new TimeCardsState(this.title, this.time);
}

class TimeCardsState extends State<TimeCards>{
  String title, time;

  TimeCardsState(this.title, this.time);

  @override
  Widget build(BuildContext context){
    return new Card(
      margin: new EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              this.title, 
              style: new TextStyle(
                fontSize: 18,
                )
            ),
            new Text(
              this.time,
              style: new TextStyle(
                fontSize: 64,
                height: 0.9,
              )
            ),
          ],
        )
      )
    );
  }
}