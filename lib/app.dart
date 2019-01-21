import 'package:flutter/material.dart';
import 'utils/container.dart';
import 'login.dart';

class Myapp extends StatelessWidget{
  var container;
  var homePage;

  @override
  Widget build(BuildContext context){
    container = StateContainer.of(context);
    homePage = new LoginPage();

    return new MaterialApp(
      theme: new ThemeData(
        buttonTheme: new ButtonThemeData(
          minWidth: 45.0,
          padding: EdgeInsets.all(0.0),
          buttonColor: Colors.blue
        )
      ),
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
      title: "Smart Home",
      home: homePage
    );
  }
}
