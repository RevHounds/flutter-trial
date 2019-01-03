import '../model/user.dart';
import '../../utils/rest-getway.dart';

abstract class ApplicationRepository{
  Future<User> saveUser(User user);
  Future<User> registerUser(User user);
  void getUser();
  void editUser(User user);
  void deleteUser(User user);
}

class MockApplicationRepository implements ApplicationRepository{
  RestGetway getway = new RestGetway();

  @override
  Future<User> registerUser(User user) async {
    return getway.register(user).then((registeredUser){
      return Future.value(registeredUser);
    });
  }

  @override
  Future<User> saveUser(User user) async {
    return Future.value(user);
  }

  @override
  void getUser(){
    
  }

  @override
  void editUser(User user){

  }
  @override
  void deleteUser(User user){

  }
}