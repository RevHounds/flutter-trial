import '../../utils/uid.dart';

class Trigger{
  String uid;
  String locationId;
  String deviceId;
  int inputPort;
  int outputPort;
  bool inputCondition;
  bool outputCondition;

  Trigger({
    this.locationId = "null",
    this.deviceId = "null",
    this.inputPort = -1,
    this.outputPort = -1,
    this.inputCondition = false,
    this.outputCondition = false
  }){
    this.uid = new IDGenerator().generateUID();
  }

  Trigger.fromMap(Map<String, dynamic> map){
    uid = map["Id"];
    deviceId = map["DeviceId"];
    locationId = map["LocationId"];
    inputPort = map["InputPort"];
    outputPort = map["OutputPort"];
    inputCondition = map["InputCondition"];
    outputCondition = map["OutputCondition"];
  }
}