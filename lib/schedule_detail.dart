import 'package:flutter/material.dart';
import 'data/model/schedule.dart';
import 'data/model/device.dart';
import 'utils/container.dart';
import 'view/schedule_presenter.dart';
import 'utils/toast.dart';

class ScheduleDetailPage extends StatefulWidget{
  static const String routeName = "/Schedule-detail";
  Schedule schedule;
  Device device;

  ScheduleDetailPage(this.schedule, this.device);

  @override
  State<ScheduleDetailPage> createState() => new ScheduleDetailPageState(this.schedule, this.device);
}

class ScheduleDetailPageState extends State<ScheduleDetailPage> implements CheckBoxTileContract{
  var container;
  String timeRep = "";
  CheckBoxTilePresenter presenter;
  Schedule schedule;
  Schedule tempSchedule;
  ListView scheduleView = new ListView();
  Device device;

  ScheduleDetailPageState(this.schedule, this.device){
    this.tempSchedule = new Schedule(repeatString: this.schedule.repeatString);
    this.presenter = new CheckBoxTilePresenter(this);
  }

  @override
  void onValueChanged(String day, bool value){
    this.tempSchedule.changeValue(day, value);
  }

  @override
  void onScheduleSaved(Schedule newSchedule){
    setState(() {
    });
  }

  String _value = "";
  Future _selectTime() async {
    TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(picked != null) setState(() {
      _value = picked.toString();
      String hour, minute;
      hour = picked.hour.toString();
      if(picked.hour.toInt() < 10){
        hour = "0" + hour;
      }
      minute = picked.minute.toString();
      if(picked.minute.toInt() < 10){
        minute = "0" + minute;
      }
      schedule.start = hour + ":" + minute;
      Toaster.create(_value);
      });
    presenter.saveSchedule(schedule, device);
  }

  List<Widget> generateListOfDay(){
    List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    List<Widget> res = new List<Widget>();

    for(String day in days){
      print(day);
      CheckBoxTile entry = new CheckBoxTile(day, schedule.repeatDay[day], presenter);
      res.add(entry);
    }
    return res;
  }

  Future _selectDay() async{
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Repeat"),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: generateListOfDay()
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                setState(() {
                  this.tempSchedule.copyRepeat(schedule.repeatDay);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton( 
              child: new Text("Ok"),
              onPressed: () {
                setState(() {
                  this.schedule.copyRepeat(tempSchedule.repeatDay);
                  print("Days: " + schedule.repeatString);
                  presenter.saveSchedule(schedule, device);
                });
                Navigator.of(context).pop();
              },
            ),
        ],
      )
    );
  }

  @override
  void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(device.name + '\'s Schedule')
      ),
      body: new ListView(
        children: <Widget>[
          new Card(
            child: new FlatButton(
              onPressed: _selectTime,
              child: new Text(
                schedule.start,
                style: new TextStyle(
                  fontSize: 100
                ),
              ),
            ),
          ),
          new Card(
            child: new FlatButton(
              onPressed: (){
                setState(() {
                  _selectDay();
                  presenter.saveSchedule(schedule, device);
                });
              },
              child: new ListTile(
                title: new Text("Repeat"),
                trailing: new Text(schedule.repeat),
              ),
            )
          ),
          new Card(
            child: new FlatButton(
              onPressed: (){
                setState(() {
                  this.schedule.status = !this.schedule.status;
                  presenter.saveSchedule(schedule, device);
                });
              },
              child: new ListTile(
                title: new Text("Command"),
                trailing: new Switch(
                  value: this.schedule.commandBool,
                  onChanged: (bool value){
                    setState(() {
                      this.schedule.commandBool = value;
                      presenter.saveSchedule(schedule, device);
                    });
                  },
                ),
              ),
            )
          )
        ],
      )
    );
  }
}

class CheckBoxTile extends StatefulWidget{
 String title;
 bool value;
 CheckBoxTilePresenter presenter;

 CheckBoxTile(this.title, this.value, this.presenter);

  @override
  State<CheckBoxTile> createState() => new CheckBoxTileState(this.title, this.value, this.presenter);
}

class CheckBoxTileState extends State<CheckBoxTile>{
  String title;
  bool value;
  CheckBoxTilePresenter presenter;
  CheckBoxTileState(this.title, this.value, this.presenter);

  @override
  Widget build(BuildContext context){
    return new ListTile(
        title: new Text(title),
        trailing: new Checkbox(
          tristate: false,
          value: value,
          onChanged: (bool res){
            setState(() {
              value = res;
              presenter.changeValue(title, res);
            });
          },
        ),
      );
  }
}