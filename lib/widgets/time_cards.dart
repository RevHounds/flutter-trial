import 'package:flutter/material.dart';

class TimeCards extends StatefulWidget{
  final String title, time;

  TimeCards(this.title, this.time);
  
  @override
  State<TimeCards> createState() => new TimeCardsState(this.title, this.time);
}

class TimeCardsState extends State<TimeCards>{
  String title, time;

  TimeCardsState(this.title, this.time);

  @override
  Widget build(BuildContext context){
    return new Card(
      margin: new EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              this.title, 
              style: new TextStyle(
                fontSize: 18,
                )
            ),
            new Text(
              this.time,
              style: new TextStyle(
                fontSize: 64,
                height: 0.9,
              )
            ),
          ],
        )
      )
    );
  }
}