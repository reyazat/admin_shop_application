import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';

class ChipWidget extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  ChipWidget({@required this.label, @required this.text, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.all(9.0),
      avatar: CircleAvatar(
        backgroundColor: MainColors.greyLight,
        child: Text(label),
      ),
      label: Text(
        text,
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: MainColors.shadow,
    );
  }
}
