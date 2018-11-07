import 'dart:async';
import '../data/model/location.dart';
import 'netowrk.dart';
import '../data/model/user.dart';
import 'toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestGetway{
  static RestGetway _instance = new RestGetway.internal();
  RestGetway.internal();
  factory RestGetway() => _instance;

  NetworkUtils _networkUtils = new NetworkUtils();

  static final baseUrl = 'https://macharoon-junly.herokuapp.com';
  static final loginUrl = baseUrl + "/login";
  static final getTokenUrl = baseUrl + "/get-token";
  static final registerUrl = baseUrl + "/register";
  static final addLocationUrl = baseUrl + "/add-location";
  static final getLocationUrl = baseUrl + "/get-locations";
  static final deleteLocationUrl = baseUrl + "/delete-location";
  static final getDevicesUrl = baseUrl + "/get-devices";
  static final addDeviceUrl = baseUrl + "/add-device";
  static final deleteDeviceUrl = baseUrl + "/delete-devices";
  static final updateDeviceUrl = baseUrl + "/update-device";

  String _authenticationKey = "";
  String _userId = "";
  String _email = "";
  String _pass = "";

  Future<User> initOnPrevData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    this._authenticationKey = pref.getString("Token");
    this._userId = pref.getString("uid");
    this._email = pref.getString("email");
    this._pass = pref.getString("password");
    User user = new User.fromApp(this._userId, this._email, this._pass);
    return Future.value(user);
  }

  Future<bool> getToken(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return _networkUtils.post(getTokenUrl, body: {
      'Email' : user.email,
      'Password' : user.password
    }          
    ).then((res){
      this._authenticationKey = res["Token"];
      this._email = user.email;
      this._pass = user.password;
      this._userId = user.uid;

      pref.setString("email", user.email);
      pref.setString("password", user.password);
      pref.setString("uid", user.uid);
      pref.setString("Token", _authenticationKey);
      return Future.value(true);
    });
  }

  Future<User> login(String email, String password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
    email = email.trim();
    password = password.trim();

    print("Email: " + email);
    print("Pass: " + password);

    return _networkUtils.post(loginUrl, body: {
        'email' : '$email',
        'password' : '$password'
      }
      ).then((dynamic res){

        print(res.toString());
        if(res["error"] == "false"){
          User user = new User.fromMap(res["user"]);
          getToken(user).then((status){
            if(status) print("yeay");
          });
          return Future.value(user);
        }
        Toaster.create("No user found!");
    });
  }

  Future<User> register(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("Adding new user request");

    return _networkUtils.post(registerUrl, body: {
      'email' : user.email,
      'password' : user.password,
      'name' : user.name,
      'image' : 'https://randomuser.me/api/portraits/thumb/men/68.jpg',
      'username' : user.name.split(" ")[0]
    }
    ).then(
      (dynamic res){
        if(res["error"] == false){
          User user = new User.fromMap(res["user"]);    
          Toaster.create("Succeeded");
      
          getToken(user).then(
            (status){
              if(status) print("yeay");
            }
          );          
          return Future.value(user);
        }
        Toaster.create("Failed to create new User");
      }
    );
  }

 Future<List<Location>> getLocations(User user) async {
      var result = await getToken(user);
      return NetworkUtils().post(getLocationUrl,
          body: {
            "id" : _userId
          },
          headers: {
            "authorization" : "Bearer " + _authenticationKey
          }
        ).then(
          (res){
            List<Location> locations = new List<Location>();
            if(res == null){
              print("There is no response body");
              return Future.value(null);
            }
            
            if(res["error"] == "true"){
              print("There is no locations found yet");
              return Future.value(locations);
            }

            res = res["locations"];
            print(res.toString());
            
            for(Map<String, dynamic> location in res){
              Location newLocation = new Location.fromMap(location);
              print("Nama Lokasi: " + newLocation.name);
              locations.add(newLocation);
            }
            return Future.value(locations);
          }
        );
  }

   Future<Location> addLocation(Location location){
    print("Adding new location to user's account");
    print(_authenticationKey);
    print("Location Name: " + location.name);
    print("Location picture: " + location.picture);
    print("User Id: " + _userId);


    return NetworkUtils().post(addLocationUrl, body: {
      "id" : location.uid,
      "name" : location.name,
      "image" : location.picture,
      "ip" : location.ip,
      "userid" : _userId
    },  
      headers: {
        "authorization" : "Bearer " + _authenticationKey
      }
    ).then(
      (res){
        print(res.toString());
        if(res["error"] == "false"){          
          return Future.value(location);
        }
        return Future.value(null);
      }
    );
  }

  Future<String> deleteLocation(String uid){
    print(uid);
    return NetworkUtils().post(deleteLocationUrl, body: {
        "id" : uid
      },
      headers: {
        "authorization" : "Bearer " + _authenticationKey
      }
    ).then((res){
      print(res.toString());
      if(res["error"] == "false")
        return Future.value(uid);
      else
        return Future.value("not found");
    });
  }

 Future<List<Device>> getDevices(Location location) async {
      return NetworkUtils().post(getDevicesUrl,
          body: {
            "id" : location.uid
          },
          headers: {
            "authorization" : "Bearer " + _authenticationKey
          }
        ).then(
          (res){
            List<Device> devices = new List<Device>();
            if(res == null){
              print("There is no response body");
              return Future.value(null);
            }
            
            if(res["error"] == "true"){
              print("There is no devices found yet");
              return Future.value(devices);
            }

            res = res["devices"];
            print(res.toString());
            
            for(Map<String, dynamic> device in res){
              Device newDevice = new Device.fromMap(device);
              print("Nama Lokasi: " + newDevice.name);
              devices.add(newDevice);
            }
            return Future.value(devices);
          }
        );
  }

   Future<Device> addDevice(Device device, Location location){
    print("Adding new Device to location");
    print(_authenticationKey);
    print("Location ID: " + location.uid);
    print("Device UID: " + device.uid);
  
    return NetworkUtils().post(addDeviceUrl, body: {
      "id" : device.uid,
      "name" : device.name,
      "port" : device.port,
      "status" : device.status,
      "description" : device.description,
      "icon" : device.icon,
      "locationid" : location.uid,
    },  
      headers: {
        "authorization" : "Bearer " + _authenticationKey
      }
    ).then(
      (res){
        print(res.toString());
        if(res["error"] == "false"){
          
          return Future.value(device);
        }
        return Future.value(null);
      }
    );
  }

  Future<String> deleteDevice(String uid){
    print(uid);
    return NetworkUtils().post(deleteDeviceUrl, body: {
        "id" : uid
      },
      headers: {
        "authorization" : "Bearer " + _authenticationKey
      }
    ).then((res){
      print(res.toString());
      if(res["error"] == "false")
        return Future.value(uid);
      else
        return Future.value("not found");
    });
  }

  Future<Device> updateDevice(Device device, Location location){
    print("Updating Device in location");
    print(_authenticationKey);
    print("Location ID: " + location.uid);
    print("Device UID: " + device.uid);
  
    return NetworkUtils().post(updateDeviceUrl, body: {
      "id" : device.uid,
      "name" : device.name,
      "locationid" : location.uid,
      "port" : device.port,
      "status" : !device.status,
      "description" : device.description,
      "icon" : device.icon,
    },  
      headers: {
        "authorization" : "Bearer " + _authenticationKey
      }
    ).then(
      (res){
        print(res.toString());
        if(res["error"] == "false"){
          print("bener masuk kok");
          device.status = !device.status;
          return Future.value(device);
        }
        return Future.value(null);
      }
    );
  }
}