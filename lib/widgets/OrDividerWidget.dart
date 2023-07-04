import 'package:flutter/material.dart';

Widget orDividerWidget() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        Text('or'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
