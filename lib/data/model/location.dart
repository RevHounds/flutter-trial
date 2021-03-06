import 'device.dart';
import '../../utils/uid.dart';

class Location{
	String uid;
	String name;
	String picture;
  String status;

  List<Device> devices;

	Location(this.uid, this.name, this.picture) {
    devices = new List<Device>();
    status = "pending";
  }

  Location.fromMap(Map<String, dynamic> map){
    this.uid = map["Id"];
    this.name = map["Name"];
    this.picture = map["Image"];
    this.status = map["Status"];
    this.devices = new List<Device>();
  }

  static Location fromView(LocationAddView view)  {
    print("Try make location");
    return new Location(view.uid, view.name, view.picture);
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
		  String uid,
			String name,
			String picture
  ) : super(uid, name, picture);
}

class LocationAddView extends LocationView{
  LocationAddView(String uid, String name)
    : super(uid, name, "https://i.pinimg.com/originals/a1/97/5f/a1975f8a0f233576745c9758bc85526e.jpg");
}
