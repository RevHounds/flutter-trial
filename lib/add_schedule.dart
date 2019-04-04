import 'package:flutter/material.dart';
import './view/schedule_presenter.dart';
import './data/model/device.dart';
import './data/model/schedule.dart';
import './data/model/location.dart';
import './utils/container.dart';
import './widgets/day_button.dart';
import './widgets/time_cards.dart';

class AddSchedulePage extends StatefulWidget{
  static const String routeName = "/schedule-detail";
  AddSchedulePage();

  @override
  State<AddSchedulePage> createState() => new AddSchedulePageState();
}

class AddSchedulePageState extends State<AddSchedulePage> implements AddSchedulePageContract{
  Device device;
  Schedule schedule;
  AddSchedulePagePresenter presenter;
  var container;
  List<Widget> components = [];
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  bool isLoading = true;

  AddSchedulePageState(){
    presenter = new AddSchedulePagePresenter(this);
    components = new List();
  }
  
  @override
  void onScheduleSaved(List<Location> locations, Device newDevice){
    container.locations = locations;
    container.onFocusDevice = newDevice;

    print("this device: " + this.device.schedules.length.toString());
    print("new Device: " + newDevice.schedules.length.toString());

    print("Sudah tersimpan dengan baik");
    Navigator.of(context).pop();
  }

  @override
  void onScheduleModified(Schedule newSchedule){
    container.onFocusSchedule = newSchedule;
    this.schedule = newSchedule;
    setState(() {
      populateComponents();
    });
  }

  @override
  void onScheduleDeleted(List<Location> locations){
    container.locations = locations;
    Navigator.of(context).pop();
  }

  void _cancelModify(){
    Navigator.of(context).pop();
  }

  void populateComponents(){
    Widget startTimeCard = new TimeCards("Start", this.schedule.start, this.schedule);
    Widget endTimeCard = new TimeCards("End", this.schedule.end, this.schedule);

    Widget rangedScheduleToggle = new ListTile(
                      title: const Text("Ranged Schedule"),
                      leading: new Checkbox(
                        value: schedule.isRanged,
                        onChanged: (bool value){
                          presenter.changeIsRanged(schedule);
                        },
                      ),
                    );

    Widget repeatDayButtons = new Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 5.0),
                    child: new Text(
                      "Repeat",
                      style: new TextStyle(
                        fontSize: 18
                      ),
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
          );

    Widget confirmationButtons = new Row(
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
                onPressed: _cancelModify
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
          );

    components = new List();

    components.add(startTimeCard);
    components.add(rangedScheduleToggle);

    if(this.schedule.isRanged){
      components.add(endTimeCard);
    }

    components.add(repeatDayButtons);          
    components.add(new Padding(padding: EdgeInsets.all(25),));
    components.add(confirmationButtons);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.device = container.onFocusDevice;
    this.schedule = container.onFocusSchedule;
    
    print(schedule.isRanged.toString());

    populateComponents();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.device.name + '\'s Schedule'),
      ),
      body: new ListView(
        children: components
      )
    );
  }
}

