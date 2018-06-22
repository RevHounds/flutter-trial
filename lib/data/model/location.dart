import '../../utils/uid.dart';

class Location{
	String uid;
	String ip;
	String name;
	String picture;

  List<Device> devices;

	Location(
			this.ip,
			this.name,
			this.picture
		) : uid = new IDGenerator().generateUID();

  static Location fromView(LocationAddView view)  {
    print("Try make location");
    return new Location(view.ip, view.name, view.picture);
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

  Device({
    this.name,
    this.status = false
  }) : uid = new IDGenerator().generateUID();
}
