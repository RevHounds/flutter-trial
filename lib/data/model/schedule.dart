import '../../utils/uid.dart';

class Schedule{
  String uid;
  String start;
  bool _command;
  Map<String, bool> repeatDay;
  String repeatString;
  bool status;

  Schedule({
    this.start = "00:00",
    this.repeatString = "None",
    this.status = true
  }){
    this._command = true;
    this.uid = new IDGenerator().generateUID();
    repeatDay = new Map<String, bool>();
    List<String> days = repeatString.split(" ");
    repeatDay["None"] = false;
    repeatDay["Monday"] = false;
    repeatDay["Tuesday"] = false;
    repeatDay["Wednesday"] = false;
    repeatDay["Thursday"] = false;
    repeatDay["Friday"] = false;
    repeatDay["Saturday"] = false;
    repeatDay["Sunday"] = false;
    for(String day in days){
      if(day == "None"){
        repeatDay["Monday"] = false;
        repeatDay["Tuesday"] = false;
        repeatDay["Wednesday"] = false;
        repeatDay["Thursday"] = false;
        repeatDay["Friday"] = false;
        repeatDay["Saturday"] = false;
        repeatDay["Sunday"] = false;
        repeatDay[day] = true;
        break;
      }
      repeatDay[day] = true;
    }
  }

  Schedule.fromMap(Map<String, dynamic> map){
    repeatDay = new Map<String, bool>();
    this.uid = map["Id"];
    this.start = map["Start"];
    this._command  = true ? false : map["Command"] == "On";
    String stats = map["Status"];
    if(stats.toLowerCase() == "true"){
      this.status = true;
    } else{
      this.status = false;
    }
    this.repeatString = map["Days"];
    List<String> days = repeatString.split(" ");
    
    print("Here");

    repeatDay["None"] = false;
    repeatDay["Monday"] = false;
    repeatDay["Tuesday"] = false;
    repeatDay["Wednesday"] = false;
    repeatDay["Thursday"] = false;
    repeatDay["Friday"] = false;
    repeatDay["Saturday"] = false;
    repeatDay["Sunday"] = false;

    for(String day in days){
      if(day == "None"){
        repeatDay["Monday"] = false;
        repeatDay["Tuesday"] = false;
        repeatDay["Wednesday"] = false;
        repeatDay["Thursday"] = false;
        repeatDay["Friday"] = false;
        repeatDay["Saturday"] = false;
        repeatDay["Sunday"] = false;
        repeatDay[day] = true;
        break;
      }
      repeatDay[day] = true;
    }
  }

  void copyRepeat(Map<String, bool> days){
    repeatString = "";
    repeatDay["Monday"] = days["Monday"];
    repeatDay["Tuesday"] = days["Tuesday"];
    repeatDay["Wednesday"] = days["Wednesday"];
    repeatDay["Thursday"] = days["Thursday"];
    repeatDay["Friday"] = days["Friday"];
    repeatDay["Saturday"] = days["Saturday"];
    repeatDay["Sunday"] = days["Sunday"];
    repeatDay["None"] = days["None"];

    if(repeatDay["None"]){
      repeatString =  "None";
      return;
    }
    String res = "";
    if(repeatDay["Monday"]) res += "Monday ";
    if(repeatDay["Tuesday"]) res += "Tuesday ";
    if(repeatDay["Wednesday"]) res += "Wednesday ";
    if(repeatDay["Thursday"]) res += "Thursday ";
    if(repeatDay["Friday"]) res += "Friday ";
    if(repeatDay["Saturday"]) res += "Saturday ";
    if(repeatDay["Sunday"]) res += "Sunday";
    repeatString = res;
  }
  
  String get repeat{
    if(repeatDay["None"]) return "None";
    String res = "";
    if(repeatDay["Monday"]) res += "Monday, ";
    if(repeatDay["Tuesday"]) res += "Tuesday, ";
    if(repeatDay["Wednesday"]) res += "Wednesday, ";
    if(repeatDay["Thursday"]) res += "Thursday, ";
    if(repeatDay["Friday"]) res += "Friday, ";
    if(repeatDay["Saturday"]) res += "Saturday, ";
    if(repeatDay["Sunday"]) res += "Sunday ";
    if (res.length >= 20){
      res = res.substring(0,17);
      res += ". . .  ";
    }
    return res.substring(0,res.length - 2);
  }

  void changeValue(String day, bool value){
    repeatDay["None"] = false;
    repeatDay[day] = value;

    if( repeatDay["Monday"]    == false &&
        repeatDay["Tuesday"]   == false &&
        repeatDay["Wednesday"] == false &&
        repeatDay["Thursday"]  == false &&
        repeatDay["Friday"]    == false &&
        repeatDay["Saturday"]  == false &&
        repeatDay["Sunday"]    == false )
        repeatDay["None"] = true;
  }

  set repeat(String req){
    List<String>days = req.split(" ");
    if(days.indexOf("None") == -1) repeatDay["None"] = false;
    for(String day in days){
      repeatDay[day] = true;
    }
  }

  get command{
    if(this._command){
      return "On";
    } else{
      return "Off";
    }
  }
  set command(bool value){
    this._command = value;
  }
}