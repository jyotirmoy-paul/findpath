import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert {
  static void showSnackBar(BuildContext context, String message,
      {milliseconds = 2000}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
