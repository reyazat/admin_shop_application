import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';

class ProductInfo extends StatelessWidget {

  final String title;
  final String value;

  const ProductInfo({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            // width: double.infinity / 2,
            alignment: Alignment.centerLeft,
            child: Text(title,
              style: TextStyle(
                color: MainColors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height / 58,
              ),
            ),
          ),
          Container(
            // width: double.infinity / 2,
            alignment: Alignment.centerLeft,
            child: Text(value,
              style: TextStyle(
                color: MainColors.grey,
                fontSize: MediaQuery.of(context).size.height / 58,
              ),
            ),
          ),
        ]
    );
  }
}
