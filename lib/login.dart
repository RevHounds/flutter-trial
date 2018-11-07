import 'package:flutter/material.dart';
import './utils/container.dart';
import './utils/rest-getway.dart';
import 'app.dart';
import 'data/model/user.dart';
import 'view/app_presenter.dart';
import 'register.dart';
import 'view/app_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  
  @override
  State<LoginPage> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> implements LoginContract{
  var emailAdressController;
  var passwordController;
  
  LoginPresenter presenter;

  var mainPage;
  var loginFormKey;
  var container;
  String _username = "";
  String _password = "";
  RestGetway getway;

  Future<bool> isLoggedIn() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var state = await pref.getBool("isLoggedIn");
    return state == null ? false : state;
  }

  LoginPageState() {
    isLoggedIn().then((isLoggedIn) async {
      if(isLoggedIn){
        print("udah, tinggal masuk aja om");
        getway.initOnPrevData().then((user){
          container.user = user;
        });
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            builder: (context){
              return new MainMenu();
            }
          ));
      }
    });

    presenter = new LoginPresenter(this);
    emailAdressController =  new TextEditingController();
    passwordController = new TextEditingController();
    loginFormKey = new GlobalKey<FormState>();
    getway = new RestGetway();
         
  }

  @override
  void onLoginSucceed(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isLoggedIn", true);
    await pref.setString("uid", user.uid);
    
    container.errorLogin = false;
    container.loggedIn = true;

    print("Known user id: " + user.uid);
    container.user = user;
  
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context){
          return new MainMenu();
        }
      )
    );
  }

  String _validateEmail(String email){
    print("email lewat");
    return "amann";
  }

  String _validatePassword(String password){
    print("pass lewat");
    return "lewat";
  }

  @override
  Widget build(BuildContext context){
    mainPage = new Myapp();
    container = StateContainer.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    Widget errorLabel = new Container(
      child: new Text("Invalid pair of email and password specified"),
      color: Colors.redAccent,
      width: screenSize.width,
    );
  
    var loginFormLayout;

    void submit() async {
    print("submit");
    _username = emailAdressController.text;
    _password = passwordController.text;

    getway.login(_username, _password).then((user){
      if(loginFormLayout == null)
          print("yea");
      
      if(user == null){
        container.errorLogin = true;
        container.loggedIn = false;
        loginFormLayout.add(errorLabel);  
        return;
      }
      presenter.loginSucceed(user);
    });
  }

    loginFormLayout = [
      new TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          hintText: 'you@example.com',
          labelText: 'E-mail Address'
        ),
        validator: this._validateEmail,
        onSaved: (String value){
          this._username = value;
        },
        controller: emailAdressController,
      ),
      new TextFormField(
        obscureText: true,
        decoration: new InputDecoration(
          hintText: 'Password',
          labelText: 'Enter your password'
        ),
        validator: this._validatePassword,
        onSaved: (String value){
          this._password = value;
        },
        controller: passwordController,
      ),
      new Container(
        width: screenSize.width,
        child: new RaisedButton(
          child: new Text(
            'Login',
            style: new TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: () {
            submit();
          },
          color: Colors.blue,
        ),
        margin: new EdgeInsets.only(
          top: 20.0
        ),
      ),
      new Container(
        width: screenSize.width,
        child: new RaisedButton(
          child: new Text(
            'Register',
            style: new TextStyle(
              color: Colors.blue
            ),
          ),
          onPressed: () {
            Navigator.pushReplacement(context, 
              new MaterialPageRoute(
                builder: (context){
                  return new RegisterPage();
                }
              )
            );
          },
          color: Colors.white,
        ),
        margin: new EdgeInsets.only(
          top: 5.0
        ),
      ),
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Form(
          key: loginFormKey,
          child: new ListView(
            children: loginFormLayout
          ),
        )
      ),
    );
  }
}