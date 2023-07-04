import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';

class SelectField extends StatelessWidget {

  final String dropdownValue;
  final List<String> dropdownItems;
  final List<String> disabledItems;
  final Icon dropdownIcon;
  final Function onChanged;

  SelectField({
    @required this.dropdownValue,
    @required this.dropdownItems,
    this.disabledItems,
    this.dropdownIcon,
    @required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue != '' ? dropdownValue : null,
      icon: dropdownIcon,
      iconEnabledColor: MainColors.white,
      isExpanded: true,
      iconSize: MediaQuery.of(context).size.height / 35,
      elevation: 16,
      style: TextStyle(color: MainColors.white, fontSize: MediaQuery.of(context).size.height / 50),
      underline: Container(
        height: 0,
      ),
      dropdownColor: Colors.black.withOpacity(0.5),
      onChanged: onChanged,
      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
            style: TextStyle(
              color: disabledItems != null && disabledItems.length > 0
                  ? (disabledItems.contains(value) ? Colors.black : null)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}