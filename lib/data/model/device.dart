import '../../utils/uid.dart';
import 'schedule.dart';

class Device{
  String uid;
  String name;
  bool status;
  String icon;
  String description;
  int port;
  List<Schedule> schedules;

  Device({
    this.name,
    this.icon = "lightbulb_outline",
    this.status = false,
    this.description = "None",
    this.port = 1,
  }) :  this.uid = new IDGenerator().generateUID(),
        this.schedules = new List<Schedule>();

  Device.fromMap(Map<String, dynamic> map){
    this.uid = map["Id"];
    this.name = map["Name"];
    this.status = map["Status"];
    this.icon = map["Icon"];
    this.description = map["Description"];
    this.port = map["Port"];
    this.schedules = new List<Schedule>();
  }
}