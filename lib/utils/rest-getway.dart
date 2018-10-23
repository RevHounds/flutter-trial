import 'dart:async';
import '../data/model/location.dart';
import 'netowrk.dart';
import '../data/model/user.dart';
import 'toast.dart';

class RestGetway{
  static RestGetway _instance = new RestGetway.internal();
  RestGetway.internal();
  factory RestGetway() => _instance;

  NetworkUtils _networkUtils = new NetworkUtils();

  static final baseUrl = 'https://macharoon-junly.herokuapp.com';
  static final loginUrl = baseUrl + "/login";
  static final registerUrl = baseUrl + "/register";
  static final addLocationUrl = baseUrl + "/";
  static final getLocationUrl = baseUrl + "/get-locations";

  static String _authentication_key = "";

  void setKey(String key){
    _authentication_key = key;
  }

  Future<User> login(String email, String password){
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
    
        if(res["error"] == null){
          User user = new User.fromMap(res["user"]);
          print(user.toString());
          
          return Future.value(user);
        }

        Toaster.create("No user found!");
    });
  }

  Future<User> register(User user){
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
          print(user.toString());
          Toaster.create("Succeeded");

          return Future.value(user);
        }

        Toaster.create("Failed to create new User");
      }
    );
  }

  Future<Location> addLocation(Location location){
    print("Adding new location to user's account");

    return NetworkUtils().post(addLocationUrl, body: {
      "location_name" : location.name,
      "location_image" : location.picture
    }).then(
      (location){
        return Future.value(location);
      }
    );
  }

  Future<List<Location>> getLocations(String userID){
    print("fetching locations");

    return NetworkUtils().post( getLocationUrl,
      body: {
        "user_id" : userID
      }
    ).then(
      (locations){
        return Future.value(locations);
      }
    );
  }
}
