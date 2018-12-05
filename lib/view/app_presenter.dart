import '../data/model/user.dart';
import '../data/repo/app_repository.dart';

import '../utils/injector.dart';

abstract class LoginContract{
  void onLoginSucceed(User user);
}

abstract class LogoutContract{
  void onLogout();
}

abstract class RegisterContract{
  void onRegisterSucceed(User user);
}

class RegisterPresenter{
  ApplicationRepository _repo;
  RegisterContract _view;

  RegisterPresenter(this._view){
    this._repo = Injector().applicationRepository;
  }

  registerSuceed(User user){
    _repo.registerUser(user).then((registeredUser){
      _view.onRegisterSucceed(registeredUser);
    });
  }
}

class LoginPresenter{
  ApplicationRepository _repo;
  LoginContract _view;

  LoginPresenter(this._view){
    this._repo = Injector().applicationRepository;
  }

  loginSucceed(User user){
    _view.onLoginSucceed(user);
  }
}

class MainMenuPresenter{
  LogoutContract _view;
  MainMenuPresenter(this._view);
  
  void logout(){
    _view.onLogout();  
  }
}