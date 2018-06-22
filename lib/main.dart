import 'package:flutter/material.dart';
import 'utils/container.dart';
import './app.dart';
import 'utils/injector.dart';

void main() {
  Injector.configure(Flavor.MOCK);
  runApp(new StateContainer(new Myapp()));
} 