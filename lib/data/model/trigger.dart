import '../../utils/uid.dart';

class Trigger{
  String uid;
  int inputPort;
  int outputPort;
  String locationId;
  bool inputCondition;
  bool outputCondition;

  Trigger({
    this.locationId = "null",
    this.inputPort = -1,
    this.outputPort = -1,
    this.inputCondition = false,
    this.outputCondition = false
  }){
    this.uid = new IDGenerator().generateUID();
  }

  Trigger.fromMap(Map<String, dynamic> map){
    this.uid = new IDGenerator().generateUID();
    locationId = map["LocationId"];
    inputPort = map["InputPort"];
    outputPort = map["OutputPort"];
    inputCondition = map["InputCondition"] == "False" ? false : true;
    outputCondition = map["OutputCondition"] == "False" ? false : true;
  }
}