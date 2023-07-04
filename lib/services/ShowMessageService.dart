
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/LoadingWidget.dart';

class ShowMessageService{

  static showSuccessMsg(message){
    return BotToast.showText(
      text:message,
      duration: Duration(seconds: 6),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      contentColor: MainColors.greenMed,
      contentPadding: EdgeInsets.all(20.0),
      textStyle: Styles.messageTextStyle,

    );
  }

  static showErrorMsg(message){
    return  BotToast.showText(
      text:message,
      duration: Duration(seconds: 6),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      contentColor: MainColors.red,
      contentPadding: EdgeInsets.all(20.0),
      textStyle: Styles.messageTextStyle,

    );
  }

  static showErrorNotify(title,subtitle){
    BotToast.showNotification(
        leading: (cancel) => SizedBox.fromSize(
            size: Size(40, 40),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.info, color: MainColors.white),
              onPressed: (){},
            )
        ),
        title: (_) => Text(title,style:Styles.messageTextStyle),
        subtitle: (_) => Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(subtitle,style:Styles.messageTextStyle),
        ),
        trailing: (cancel) => IconButton(
          icon: Icon(FontAwesomeIcons.times,color: MainColors.white),
          onPressed: cancel,
        ),
        backgroundColor: MainColors.red,
        enableSlideOff: true,
        borderRadius: 15.0,
        backButtonBehavior: BackButtonBehavior.none,
        crossPage: true,
        contentPadding: EdgeInsets.all(10),
        onlyOne: true,
        animationDuration:
        Duration(milliseconds: 200),
        animationReverseDuration:
        Duration(milliseconds: 200),
        duration: null);

  }

  static showSuccessNotify(title){
    BotToast.showNotification(
        leading: (cancel) => SizedBox.fromSize(
            size: Size(40, 40),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.info, color: MainColors.white),
              onPressed: (){},
            )
        ),
        title: (_) => Text(title,style:Styles.messageTextStyle),
        trailing: (cancel) => IconButton(
          icon: Icon(FontAwesomeIcons.times,color: MainColors.white),
          onPressed: cancel,
        ),
        backgroundColor: MainColors.greenMed,
        enableSlideOff: true,
        borderRadius: 15.0,
        backButtonBehavior: BackButtonBehavior.none,
        crossPage: true,
        contentPadding: EdgeInsets.all(10),
        onlyOne: true,
        animationDuration:
        Duration(milliseconds: 200),
        animationReverseDuration:
        Duration(milliseconds: 200),
        duration: null);

  }

  static showNotify(Widget title,Widget subtitle){
    BotToast.showNotification(

        title: (_) =>title,
        subtitle: (_) =>subtitle,
        trailing: (cancel) => IconButton(
          icon: Icon(FontAwesomeIcons.times,color: MainColors.white),
          onPressed: cancel,
        ),
        backgroundColor: MainColors.blue,
        enableSlideOff: true,
        borderRadius: 15.0,
        backButtonBehavior: BackButtonBehavior.none,
        crossPage: true,
        contentPadding: EdgeInsets.all(10),
        onlyOne: true,
        animationDuration:
        Duration(milliseconds: 200),
        animationReverseDuration:
        Duration(milliseconds: 200),
        duration: null);

  }

  static showLoading({Function onClose}){
    BotToast.showCustomLoading(
        toastBuilder: (func) => LoadingWidget(),
      onClose: onClose
    );
  }

  static closeLoading(){
    BotToast.closeAllLoading();
  }


}