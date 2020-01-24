import 'package:flutter/material.dart';
import 'package:path/path.dart';

bool isNumeric(String value) {
  if (value.isEmpty) return false;
  final number = double.tryParse(value);

  return number != null ? true : false;
}

showAlert(BuildContext context, String msg) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding: EdgeInsets.zero,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          'Información Incorrecta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
