import 'package:flutter/material.dart';
import '../data/model/device.dart';
import '../device_trigger.dart';
import '../utils/container.dart';

class InputDeviceTile extends StatefulWidget{
  Device device;
  InputDeviceTile(this.device);
  @override
  InputDeviceTileState createState() => new InputDeviceTileState(device);
}

class InputDeviceTileState extends State<InputDeviceTile>{
  Device device;
  InputDeviceTileState(this.device);
  var container;

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    if(device == null) return null;

    return new Card(
      child: FlatButton(
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context){
                container.onFocusDevice = this.device;
                return new DeviceTriggerPage();
              }
            )
          );
        },
        child:  new ListTile(
          leading: new Icon(Icons.lightbulb_outline),
          title: new Text(device.name),
          subtitle: new Text("Input (" + device.port.toString() + ")"),
          trailing: new Text(
            (device.status) ? "TRUE" : "FALSE"
          )
        ),
      )
    );
  }
}