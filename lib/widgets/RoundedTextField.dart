import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';

class UnderlinedTextField extends StatelessWidget {
  final String label;
  final bool readOnly;
  final void Function() onTap;
  final TextInputType keyboardType;
  final TextEditingController controller;

  UnderlinedTextField({
    this.label,
    this.onTap,
    this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onTap: onTap,
        readOnly: readOnly,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: MainColors.mainColor),
          border: UnderlineInputBorder(borderSide: BorderSide(color: MainColors.mainColor, width: 1.5)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: MainColors.mainColor, width: 1.5)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: MainColors.mainColor, width: 1.5)),
          isDense: true,
        ),
      ),
    );
  }
}
