import 'package:flutter/material.dart';
import 'login.dart';
import 'utils/container.dart';
import 'utils/rest-getway.dart';
import 'view/app_presenter.dart';
import 'data/model/user.dart';
import 'utils/toast.dart';
import 'main_menu.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<RegisterPage> createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> implements RegisterContract{
  RestGetway getway;
  RegisterPresenter presenter;

  var container;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  RegisterPageState(){
    presenter = new RegisterPresenter(this);
    getway = new RestGetway();
    
    nameController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    confirmPasswordController = new TextEditingController();
  }

  @override
  void onRegisterSucceed(User user) async {
    container.user = user;

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context){
          return new MainMenu();
        }
      )
    );
  }

  void submit(){
    String name;
    String email;
    String password;
    String confirmPassword;
    

    name = nameController.text.trim();
    email = emailController.text.trim();
    password = passwordController.text.trim();
    confirmPassword = confirmPasswordController.text.trim();

    if(name == "" || email == "" || password == "" || confirmPassword == ""){
      Toaster.create("No fields should be left empty!");
      return;
    }

    if(password != confirmPassword){
      Toaster.create("You entered a different password on the confirm password field");
      return;
    }
    
    presenter.registerSuceed(new User(name, email, password, "https://randomuser.me/api/portraits/thumb/men/68.jpg"));
  }

  @override
  Widget build(BuildContext context){
    
    container = StateContainer.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    var registerFormLayout = [
    new TextFormField(
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        hintText: "John Doe",
        labelText: "Full Name"
      ),
      controller: nameController,
    ),
    new TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: new InputDecoration(
        hintText: "you@example.com",
        labelText: "Email"
      ),
      controller: emailController,
    ),
    new TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        labelText: "Password"
      ),
      controller: passwordController,
    ),
    new TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        labelText: "Confirm Password"
      ),
      controller: confirmPasswordController,
    ),
    new Container(
      width: screenSize.width,
      child: new RaisedButton(
          child: new Text("Register",
            style: new TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: submit,
          color: Colors.blue,
        ),
        margin: new EdgeInsets.only(top: 20.0),
    ),
      new Container(
        width: screenSize.width,
        child: new RaisedButton(
            child: new Text("Login",
              style: new TextStyle(
                color: Colors.blue
              ),
            ),
            onPressed: (){
              Navigator.of(context).pushReplacement(
                new MaterialPageRoute(
                  builder: (context){
                    return new LoginPage();
                  }
                )
              );
            },
            color: Colors.white,
          ),
          margin: new EdgeInsets.only(top: 5.0),
      )
  ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Register"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child:
          new Form(
            child: new ListView(
              children: registerFormLayout,
            ),
        ),
      )
    );
  }
}