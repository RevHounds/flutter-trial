import '../data/model/user.dart';
import '../data/repo/app_repository.dart';

import '../utils/injector.dart';

abstract class LoginContract{
  void onLoginSucceed(User user);
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
    _repo.registerUser(user).then((user){
      _view.onRegisterSucceed(user);
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
    _repo.saveUser(user).then((user){
      _view.onLoginSucceed(user);
    });
  }
}