import 'package:fluttertoast/fluttertoast.dart';

class Toaster{

  static void create(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      textcolor: '#ffffff'
    );
  }
}