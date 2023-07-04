
import 'package:flutter/material.dart';

class CircleContainerWidget extends StatelessWidget {
  final double size;
  final Color  color;
  CircleContainerWidget(this.size,this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: color),
      height: size,
      width: size,
    );
  }
}