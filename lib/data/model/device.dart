import '../../utils/uid.dart';
import 'trigger.dart';
import 'schedule.dart';

class Device{
  int port;
  bool status;
  String uid;
  String name;
  String icon;
  String type;
  String description;
  List<Schedule> schedules;
  List<Trigger> triggers;
  String locationId;

  Device({
    this.locationId = "",
    this.name,
    this.icon = "lightbulb_outline",
    this.status = false,
    this.description = "None",
    this.port = 1,
    this.type = "",
  }) :  this.uid = new IDGenerator().generateUID(),
        this.schedules = new List<Schedule>(),
        this.triggers = new List<Trigger>();

  Device.fromMap(Map<String, dynamic> map){
    this.uid = map["LocationId"];
    this.uid = map["Id"];
    this.name = map["Name"];
    this.status = map["Status"];
    this.icon = map["Icon"];
    this.description = map["Description"];
    this.port = map["Port"];
    this.type = map["Type"];
    this.schedules = new List<Schedule>();
    this.triggers = new List<Trigger>();
  }
}