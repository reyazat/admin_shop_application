import 'package:flutter/cupertino.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';

class SwitchField extends StatelessWidget {
  final bool value;
  final String label;
  final void Function(bool) onChanged;

  SwitchField(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: Styles.textLabStyle.copyWith(fontWeight: FontWeight.w400),
        ),
        Transform.scale(
          scale: .8,
          child: CupertinoSwitch(
            value: value,
            activeColor: MainColors.mainColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
