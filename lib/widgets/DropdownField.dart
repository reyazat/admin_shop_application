import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';

class DropdownField extends StatelessWidget {

  final String selectedValue;
  final List<String> items;
  final Function(String) onChanged;
  final String labelText;
  final String hintText;

  DropdownField({
    @required this.selectedValue,
    @required this.items,
    @required this.onChanged,
    @required this.labelText,
    @required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 20,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.map((label) => DropdownMenuItem(
          child: Text(label,
            style: TextStyle(fontSize: MediaQuery.of(context).size.height / 60, color: MainColors.dark),
          ),
          value: label,
        )).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
          hintStyle: Styles.textHintStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
          /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 4),
          ),*/
          border: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }
}
