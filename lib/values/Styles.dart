import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/SizeStyles.dart';

class Styles {
  static final textLabStyle = TextStyle(
    fontSize: SizeStyles.textL,
    color: MainColors.dark,
    fontWeight: FontWeight.w600,
  );
  static final textLargeLabStyle = TextStyle(
    fontSize: SizeStyles.textXL,
    color: MainColors.dark,
    fontWeight: FontWeight.w700,
  );
  static final errorTextStyle = TextStyle(
    fontSize: SizeStyles.textL,
    color: MainColors.red,
    fontWeight: FontWeight.w700,
  );
  static final messageTextStyle = TextStyle(
    fontSize: 17.0,
    color: MainColors.white,
    fontWeight: FontWeight.w700,
  );
  static final textHintStyle = TextStyle(
    fontSize: SizeStyles.textM,
    color: MainColors.grey,
    fontWeight: FontWeight.w600,
  );

  static final textStyle = TextStyle(
    fontSize: SizeStyles.textL,
    color: MainColors.darkLight,
    fontWeight: FontWeight.w400,
  );

  static final textSubtitleStyle = TextStyle(
    fontSize: 14,
    color: MainColors.darkLight,
    fontWeight: FontWeight.w400,
  );

  static final textTitleStyle = TextStyle(
    fontSize: SizeStyles.textXXL,
    color: MainColors.white,
    fontWeight: FontWeight.bold,

  );
  static final textActionStyle = TextStyle(
    inherit: false,
    fontSize: 16.9,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
  );
  static final buttonStyle = ButtonStyle(
    alignment: Alignment.center,
    foregroundColor: MaterialStateProperty.all<Color>(MainColors.subMainColor),
    backgroundColor: MaterialStateProperty.all<Color>(MainColors.mainColor),
    shadowColor: MaterialStateProperty.all<Color>(MainColors.shadow),
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10,horizontal: 15)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        )),
    minimumSize: MaterialStateProperty.all(Size(double.infinity,50)),
    elevation: MaterialStateProperty.all<double>(10),
  );
  static final buttonDialogStyle = ButtonStyle(
    alignment: Alignment.center,
    foregroundColor: MaterialStateProperty.all<Color>(MainColors.subMainColor),
    backgroundColor: MaterialStateProperty.all<Color>(MainColors.mainColor),
    shadowColor: MaterialStateProperty.all<Color>(MainColors.shadow),
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10,horizontal: 15)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        )),
    minimumSize: MaterialStateProperty.all(Size(3,50)),
    elevation: MaterialStateProperty.all<double>(10),
  );
  static final inputBorderDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    borderSide: BorderSide(
      color: MainColors.greyLight,
    ),
  );
  static final inputErrorBorderDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    borderSide: BorderSide(
      color: MainColors.red,
    ),
  );
}
