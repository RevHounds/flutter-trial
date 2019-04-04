import 'package:flutter/material.dart';
import '../data/model/schedule.dart';
import '../data/model/device.dart';
import '../data/model/location.dart';
import '../view/schedule_presenter.dart';
import '../utils/container.dart';
import '../schedule_detail.dart';

class ScheduleCard extends StatefulWidget{
  Schedule schedule;
  Device device;
  ScheduleCard(this.schedule, this.device);
  @override
  State<ScheduleCard> createState() => new ScheduleCardState(this.schedule, this.device);
}

class ScheduleCardState extends State<ScheduleCard> implements ScheduleCardContract{
  Schedule schedule;
  Device device;
  ScheduleCardPresenter presenter;
  var container;

  ScheduleCardState(this.schedule, this.device){
    this.presenter = new ScheduleCardPresenter(this);
  }

  @override
  void onScheduleUpdated(List<Location> locations){
    container.locations = locations;
    setState(() {
    });
  }

  void _onStatusChanged(bool value){
    print("something just happened");
    setState(() {
      schedule.status = !schedule.status;
      presenter.saveSchedule(schedule, device);
    });
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    return new Card(
      child: new FlatButton(
        child: new ListTile(
          title: new Text(schedule.start + " - " + schedule.command),
          subtitle: new Text(schedule.repeat),
          trailing: new Switch(
            activeColor: Colors.blue,
            value: schedule.status,
            onChanged: _onStatusChanged,
          ),
        ),
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context){
                container.onFocusSchedule = this.schedule;
                container.onFocusDevice = this.device;
                return new ScheduleDetailPage();
              }
            )
          );
        },
      ),
    );  
  }
}