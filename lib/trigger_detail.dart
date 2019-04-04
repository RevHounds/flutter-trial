import 'package:flutter/material.dart';
import './view/schedule_presenter.dart';
import './data/model/device.dart';
import './data/model/trigger.dart';
import './data/model/location.dart';
import './utils/container.dart';
import './widgets/day_button.dart';
import './widgets/time_cards.dart';

class TriggerDetail extends StatefulWidget{
  static const String routeName = "/schedule-detail";
  TriggerDetail();

  @override
  State<TriggerDetail> createState() => new TriggerDetailState();

}
class TriggerDetailState extends State<TriggerDetail> implements TriggerDetailContract{
  Device device;
  Trigger trigger;
  TriggerDetailPresenter presenter;
  var container;
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  bool isLoading = true;

  TriggerDetailState(){
    this.presenter = new TriggerDetailPresenter(this);
  }
  
  @override
  void onTriggerSaved(List<Location> locations, Device device){
    container.locations = locations;
    container.onFocusDevice = device;
    Navigator.of(context).pop();
  }

  @override
  void onTriggerModified(Trigger newTrigger){
    container.onFocusTrigger = newTrigger;
    this.trigger = newTrigger;
    setState(() {});
  }

  @override
  void onTriggerDeleted(List<Location> locations){
    container.locations = locations;
    Navigator.of(context).pop();
  }

  Future<Null> popUpDeleteSchedule() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete Trigger'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Are you sure you wanted to delete this trigger?")
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
                presenter.deleteTrigger(this.trigger, this.device);
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

  void _cancelModify(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.device = container.onFocusDevice;
    this.trigger = container.onFocusTrigger;
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Trigger Detail"),
      ),
    );
  }
}