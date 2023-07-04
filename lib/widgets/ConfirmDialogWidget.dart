import 'package:flutter/material.dart';

class ConfirmDialogWidget {
  static Future<bool> show(
    BuildContext context, {
    String title,
    String message = '',
    Widget no,
    Widget yes,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: message.isNotEmpty ? Text(message) : null,
          title: Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: <Widget>[
            TextButton(
              child: no,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: yes,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
