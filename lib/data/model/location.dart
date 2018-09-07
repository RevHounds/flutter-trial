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
      devices.add(new Device(name: "Lampu Depan"));
    }

  Location.fromMap(Map<String, dynamic> map){
    
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
    : super('127.0.0.1', name, "http://www.for-example.org/img/main/forexamplelogo.png");
}

class Device{
  String uid;
  String name;
  bool status;
  String icon;
  String description;
  Device({
    this.name,
    this.icon = "lightbulb_outline",
    this.status = false,
    this.description = "None"
  }) : uid = new IDGenerator().generateUID();
}
