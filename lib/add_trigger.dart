import 'package:flutter/material.dart';
import './view/schedule_presenter.dart';
import './data/model/device.dart';
import './data/model/trigger.dart';
import './data/model/location.dart';
import './utils/container.dart';

class AddTriggerPage extends StatefulWidget{
  static const String routeName = "/add-trigger";
  AddTriggerPage();

  @override
  State<AddTriggerPage> createState() => new AddTriggerPageState();
}

class AddTriggerPageState extends State<AddTriggerPage> implements AddTriggerPageContract{
  Device device;
  List<Device> outputs;
  Trigger trigger;
  AddTriggerPagePresenter presenter;
  var container;
  List<Widget> components = [];
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  bool isLoading = true;

  AddTriggerPageState(){
    presenter = new AddTriggerPagePresenter(this);
    components = new List();
  }
  
  @override
  void onTriggerSaved(List<Location> locations, Device newDevice){
    container.locations = locations;
    container.onFocusDevice = newDevice;

    print("this device: " + this.device.schedules.length.toString());
    print("new Device: " + newDevice.schedules.length.toString());

    print("Sudah tersimpan dengan baik");
    Navigator.of(context).pop();
  }

  @override
  void onTriggerModified(Trigger newTrigger){
    container.onFocusTrigger = newTrigger;
    this.trigger = newTrigger;
    setState(() {
      populateComponents();
    });
  }

  @override
  void onTriggerDeleted(List<Location> locations){
    container.locations = locations;
    Navigator.of(context).pop();
  }

  void _cancelModify(){
    Navigator.of(context).pop();
  }

  void _inputConditionChanged(bool value){
    setState(() {
      this.trigger.inputCondition = value;
    });
  }

  void _outputConditionChanged(bool value){
    setState(() {
      this.trigger.outputCondition = value;
    });
  }

  void populateComponents(){
    /////////perlu dibikin ui nya di sini
    
    Widget inputConditionContainer = new Card(
      child: new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),        
        child: new Column(
        children: <Widget>[
          new Align(
            alignment: Alignment.centerLeft,
            child: new Text(
            "If switch is ",
            style: new TextStyle(
              fontSize: 18,
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: this.trigger.inputCondition,
                      groupValue: true,
                      onChanged: (bool val){_inputConditionChanged(true);},
                    ),
                    new Text(
                      "True",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54
                      ),
                    ),
                  ],
                ),
                onPressed: (){_inputConditionChanged(true);},
              ),
              new FlatButton(
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: !this.trigger.inputCondition,
                      groupValue: true,
                      onChanged: (bool val){_inputConditionChanged(false);},
                    ),
                    new Text(
                      "False",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54
                      ),
                    ),
                  ],
                ),
                onPressed: (){_inputConditionChanged(false);},
              )
            ],
          ) 
        ],
      ),
      ), 
    );

    Widget outputConditionContainer = new Card(
      child: new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),        
        child: new Column(
        children: <Widget>[
          new Align(
            alignment: Alignment.centerLeft,
            child: new Text(
            "Then",
            style: new TextStyle(
              fontSize: 18,
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: this.trigger.outputCondition,
                      groupValue: true,
                      onChanged: (bool val){_outputConditionChanged(true);},
                    ),
                    new Text(
                      "Turn on",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54
                      ),
                    ),
                  ],
                ),
                onPressed: (){_outputConditionChanged(true);},
              ),
              new FlatButton(
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: !this.trigger.outputCondition,
                      groupValue: true,
                      onChanged: (bool val){_outputConditionChanged(false);},
                    ),
                    new Text(
                      "Turn off",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54
                      ),
                    ),
                  ],
                ),
                onPressed: (){_outputConditionChanged(false);},
              )
            ],
          ),
          new Align(
            alignment: Alignment.centerLeft,
            child: new Text(
              "Port No:",
              style: new TextStyle(
                fontSize: 18
              ),
            ),
          ),
           
        ],
      ),
      ), 
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
                  presenter.saveTrigger(this.trigger, this.device);
                },
              ),
            ],
          );

    components = new List();

    components.add(inputConditionContainer);
    components.add(outputConditionContainer);
      
    components.add(new Padding(padding: EdgeInsets.all(25),));
    components.add(confirmationButtons);
  }

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    this.device = container.onFocusDevice;
    this.trigger = container.onFocusTrigger;
    
    populateComponents();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.device.name + '\'s Triggers'),
      ),
      body: new ListView(
        children: components
      )
    );
  }
}

