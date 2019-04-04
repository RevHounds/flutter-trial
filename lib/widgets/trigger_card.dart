import 'package:flutter/material.dart';
import '../data/model/trigger.dart';
import '../data/model/device.dart';
import '../data/model/location.dart';
import '../view/schedule_presenter.dart';
import '../utils/container.dart';
import '../trigger_detail.dart';

class TriggerCard extends StatefulWidget{
  Trigger trigger;
  Device device;
  TriggerCard(this.trigger, this.device);
  @override
  State<TriggerCard> createState() => new TriggerCardState(this.trigger, this.device);
}

class TriggerCardState extends State<TriggerCard> implements TriggerCardContract{
  Trigger trigger;
  Device device;
  TriggerCardPresenter presenter;
  var container;

  TriggerCardState(this.trigger, this.device){
    this.presenter = new TriggerCardPresenter(this);
  }

  @override
  void onTriggerUpdated(List<Location> locations){
    container.locations = locations;
    setState(() {
    });
  }

  void _onStatusChanged(bool value){
    print("something just happened");
    setState(() {
      presenter.saveTrigger(trigger, device);
    });
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);

    return new Card(
      child: new FlatButton(
        child: new ListTile(
          title: new Text("Turn port " + trigger.outputPort.toString()),
          trailing: new Text(
            (trigger.outputCondition) ? "ON" : "OFF"
          )
        ),
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context){
                container.onFocusTrigger = this.trigger;
                container.onFocusDevice = this.device;
                return new TriggerDetail();
              }
            )
          );
        },
      ),
    );  
  }
}