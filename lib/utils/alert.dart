import 'package:flutter/material.dart';

class Alert {
  static void showSnackBar(BuildContext context, String message,
      {milliseconds = 1000}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
