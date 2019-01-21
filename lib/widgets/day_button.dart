import 'package:flutter/material.dart';
import '../data/model/schedule.dart';
import '../view/schedule_presenter.dart';

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
