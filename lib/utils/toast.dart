import 'package:fluttertoast/fluttertoast.dart';

class Toaster{

  static void create(
    String msg,
  ){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      bgcolor: "#e74c3c",
      textcolor: '#ffffff'
    );
  }
}