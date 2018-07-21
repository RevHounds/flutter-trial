import 'package:flutter/material.dart';
import 'utils/container.dart';
import './app.dart';
import 'utils/injector.dart';

class Starter{
  Stater(){
    Injector.configure(Flavor.MOCK);
    runApp(new StateContainer(new Myapp()));
  }
}

void main() {
  new Starter();
}