import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';

class InputBuildWidget extends StatelessWidget {

  final String value;
  final TextInputType inputType;
  final String hint;
  final String label;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final Color color;
  final Widget icon;
  TextEditingController controller;

  InputBuildWidget({
    this.value = '',
    this.inputType = TextInputType.text,
    this.hint = '',
    this.label = '',
    this.enabled = true,
    this.maxLength = 50,
    this.maxLines = 1,
    this.color = MainColors.black,
    this.icon,
  }) {
    controller = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 20,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        // focusNode: _focusNode,
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: inputType,
        obscureText: inputType == TextInputType.visiblePassword,
        style: TextStyle(fontSize: MediaQuery.of(context).size.height / 60, color: MainColors.dark),
        textInputAction: TextInputAction.done,
         //maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
          hintStyle: Styles.textHintStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(30),
          //   borderSide: BorderSide(color: Colors.white, width: 4),
          // ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  String getValue() => controller.text;
}
