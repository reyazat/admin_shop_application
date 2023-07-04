
import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';

class RowInfo extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Function iconAction;

  RowInfo({
    @required this.title,
    @required this.value,
    this.icon,
    this.iconAction
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: screenWidth / 3,
            alignment: Alignment.centerLeft,
            child: Text(title,
              style: TextStyle(
                color: MainColors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenHeight / 55,
              ),
            ),
          ),
          Container(
            width: screenWidth / 2,
            alignment: Alignment.centerLeft,
            child: Text(value,
              style: TextStyle(
                color: MainColors.darkLight,
                fontSize: screenHeight / 55,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth / 4,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: iconAction,
                child: Icon(icon,
                  color: MainColors.mainColor,
                  size: screenHeight / 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
