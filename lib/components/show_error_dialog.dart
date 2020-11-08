import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Okay')),
        ],
      )
  );
}
