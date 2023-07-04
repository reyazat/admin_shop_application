import 'dart:convert' show utf8;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';

class Utility{
  static String decodeUtf8(String text){
    var unescape = HtmlUnescape();
    text = unescape.convert(text);
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'),' ');
    var encoded = utf8.encode(text.toString());
    var decode = (utf8.decode(encoded));
    return decode;

  }
  static String isEmpty(String value) {
    if(value != null && value != '' && value.isNotEmpty)
      return null;
    else
      return Constants.required;
  }

  static String phoneNumberValidator(String value) {
    String pattern = r'(^(?:[0]0)?[0-9]{9}$)';
    RegExp regExp = new RegExp(pattern);
     if (value.length == 0 || (!regExp.hasMatch(value))) {
      return Constants.ukMobileNum;
    }
    return null;
  }


  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return Constants.invalidEmail;
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.length < 8)
      return Constants.invalidPass;
    else
      return null;
  }

  static Future<String> getSessionId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.androidId}');
      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.identifierForVendor}');
      return iosInfo.identifierForVendor;
    }else{
      return null;
    }
  }

  static updatePref(Type type, dynamic key) async {
    dynamic res ;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(type == int){
      res = preferences.getInt(key);
    }else if(type == String){
      res = preferences.getString(key);
    }else if(type == bool){
      res = preferences.getBool(key);
    }else if(type == double){
      res = preferences.getDouble(key);
    }else if(type == List){
      res = preferences.getStringList(key);
    }else{
      res = preferences.get(key);
    }
    return res;
  }

  static lunchAddress(BuildContext context, String address) async {
    String url ;
    String encodeAddress = Uri.encodeComponent(address);
    if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$encodeAddress';
    }else{
      url = 'https://maps.google.com/?q=$encodeAddress';
    }
    await _lunchUrl(context, url);
  }
  static lunchTelegram(BuildContext context, String telegramAccount) async {
    await _lunchUrl(context, 'https://t.me/$telegramAccount');
  }
  static lunchInstagram(BuildContext context, String instagramAccount) async {
    await _lunchUrl(context, 'instagram://user?username=$instagramAccount');
  }
  static lunchCall(BuildContext context, String phoneNumber) async {
    phoneNumber = phoneNumber.trim();
    phoneNumber = phoneNumber.replaceAll(' ','');
    await _lunchUrl(context, 'tel:$phoneNumber');
  }
  static lunchSms(BuildContext context, String phoneNumber) async {
    phoneNumber = phoneNumber.trim();
    phoneNumber = phoneNumber.replaceAll(' ','');
    await _lunchUrl(context, 'sms:$phoneNumber');
  }
  static lunchUrl(BuildContext context, String url) async {
    await _lunchUrl(context, url);
  }
  static lunchMailTo(BuildContext context, {String email , String subject, String body}) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': subject,
          'body' : body
        }
    );
    await _lunchUrl(context, _emailLaunchUri.toString());
  }

  static Future _lunchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
     LoggerService.logger.e('Could not launch $url');
    }
  }

}
