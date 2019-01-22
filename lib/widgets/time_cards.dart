import 'package:flutter/material.dart';
import '../data/model/schedule.dart';
import '../utils/toast.dart';
import '../view/schedule_presenter.dart';
import '../utils/container.dart';

class TimeCards extends StatefulWidget{
  final String title, time;
  final Schedule schedule;

  TimeCards(this.title, this.time, this.schedule);
  
  @override
  State<TimeCards> createState() => new TimeCardsState(this.title, this.time, this.schedule);
}

class TimeCardsState extends State<TimeCards> implements TimeCardContract{
  String title, time;
  Schedule schedule;
  TimeCardPresenter presenter;
  var container;

  TimeCardsState(this.title, this.time, this.schedule){
    this.presenter = new TimeCardPresenter(this);
  }

  @override
  onTimeChanged(String time, Schedule schedule){
    container.onFocusSchedule = schedule;
    this.time = time;
    setState(() {});
  }

  String _value = "";
  String selectedTIme = "";
  Future _selectTime(String determiner) async {
    TimeOfDay initial;
    int hour, minute;
    determiner = determiner.toLowerCase();
    if(determiner == "start"){
      hour = int.parse(schedule.start.substring(0,2));
      minute = int.parse(schedule.start.substring(3,5));
    } else{
      hour = int.parse(schedule.end.substring(0,2));
      minute = int.parse(schedule.end.substring(3,5));
    }
    initial = TimeOfDay(hour: hour, minute: minute);
    TimeOfDay picked = await showTimePicker(
      initialTime: initial,
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
      selectedTIme = hour + ":" + minute;
      Toaster.create(selectedTIme);
      });
    presenter.changeTime(determiner, selectedTIme, schedule);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
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
            new FlatButton(
              child: new Text(
                this.time,
                style: new TextStyle(
                  fontSize: 64,
                  height: 0.9,
                )
              ),
              onPressed: (){
                _selectTime(this.title);
              },
            )
          ],
        )
      ),
    );
  }
}