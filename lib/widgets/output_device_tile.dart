import 'package:flutter/material.dart';
import '../data/model/device.dart';
import '../view/location_presenter.dart';
import '../device_schedule.dart';
import '../utils/container.dart';

class OutputDeviceTile extends StatefulWidget{
  Device device;
  OutputDeviceTile(this.device);
  @override
  OutputDeviceTileState createState() => new OutputDeviceTileState(device);
}

class OutputDeviceTileState extends State<OutputDeviceTile> implements OutputDeviceTileStateContract{
  Device device;
  OutputDevicePresenter _devicePresenter;
  OutputDeviceTileState(this.device);
  var container;

  @override
  void onDeviceStateChanged(device) {
    this.device = device;
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
              _devicePresenter.changeDeviceStatus(device, value);
            },
          ),
        ),
      )
    );
  }
}