import 'package:flutter/material.dart';
import '../data/model/device.dart';
import '../view/device_presenter.dart';
import '../device_schedule.dart';
import '../utils/container.dart';

class OutputDeviceTile extends StatefulWidget{
  Device device;
  OutputDeviceTile(this.device);
  @override
  OutputDeviceTileState createState() => new OutputDeviceTileState(device);
}

class OutputDeviceTileState extends State<OutputDeviceTile> implements OutputDeviceTileContract{
  var container;
  Device device;
  OutputDeviceTilePresenter _devicePresenter;
  OutputDeviceTileState(this.device){
    this._devicePresenter = new OutputDeviceTilePresenter(this);
  }

  @override
  void onStateChanged(Device device) {
    setState(() {
      this.device = device;
      print(this.device.status.toString());
    });
  }

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
                return new DeviceDetailPage();
              }
            )
          );
        },
        child: new ListTile(
          leading: new Icon(Icons.lightbulb_outline),
          title: new Text(device.name),
          subtitle: new Text(device.port.toString()),
          trailing: new Switch(
            value: this.device.status,
            onChanged: (bool value){
              _devicePresenter.changeDeviceState(device, value);
            },
          ),
        ),
      )
    );
  }
}