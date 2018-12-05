import 'device.dart';
import '../../utils/uid.dart';

class Location{
	String uid;
	String ip;
	String name;
	String picture;

  List<Device> devices;

	Location(this.ip, this.name, this.picture) {
      uid = new IDGenerator().generateUID();
      devices = new List<Device>();
    }

  Location.fromMap(Map<String, dynamic> map){
    this.uid = map["Id"];
    this.name = map["Name"];
    this.picture = "http://www.for-example.org/img/main/forexamplelogo.png";
    this.ip = map["Ip"];
    this.devices = new List<Device>();
  }

  static Location fromView(LocationAddView view)  {
    print("Try make location");
    return new Location(view.ip, view.name, view.picture);
  }

  bool isEqualWithLocation(Location anotherLocation){
    return this.uid == anotherLocation.uid;
  }

  bool isEqualWithUID(String uid){
    return this.uid == uid;
  }
}

class LocationView extends Location{
  LocationView(
		  String ip,
			String name,
			String picture
  ) : super(ip, name, picture);
}

class LocationAddView extends LocationView{
  LocationAddView(String name, String address)
    : super(address, name, "http://www.for-example.org/img/main/forexamplelogo.png");
}
