import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class AppToast {
  static success(String msg) => Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
        //green hex color

        webBgColor: '#33cc33', //green hex color
      );

  static error(String msg) => Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        //red hex color

        webBgColor: '#ff0000', //red hex color
      );
}
