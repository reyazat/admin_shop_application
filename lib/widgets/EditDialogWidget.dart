
import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';

class EditDialogWidget extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget childYes;
  final Widget childNo;
  final Function onPressNo;
  final Function onPressYes;

  EditDialogWidget({
    Key key,
    this.title,
    this.content,
    this.onPressNo,
    this.onPressYes,
    this.childNo,
    this.childYes
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MainColors.backGrand,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      titleTextStyle: Styles.textLargeLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 55),
      contentTextStyle: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
      actionsPadding: EdgeInsets.zero,
      scrollable: true,
      title: title!=null ? title : null,
      content: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width - 50,
        child: SingleChildScrollView(
          child: content!=null?content:SizedBox(),
        ),
      ),
      actions: <Widget>[
        Divider(thickness: 1,),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: onPressNo,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0 * MediaQuery.textScaleFactorOf(context),
                      horizontal: MediaQuery.of(context).size.width / 9
                  ),
                  alignment: Alignment.center,
                  child: childNo,
                ),
              ),
              VerticalDivider(thickness: 1, indent: 0, endIndent: 0,),
              InkWell(
                onTap: onPressYes,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0 * MediaQuery.textScaleFactorOf(context),
                      horizontal: MediaQuery.of(context).size.width / 9
                  ),
                  alignment: Alignment.center,
                  child: childYes,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
