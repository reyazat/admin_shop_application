
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:smartshopadmin/network/SignInNetwork.dart';
import 'package:smartshopadmin/provider/Auth/AuthHelper.dart';
import 'package:smartshopadmin/provider/Auth/AuthState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:smartshopadmin/screens/auth/SignInScreen.dart';
import 'package:smartshopadmin/services/FirebaseNotificationService.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final signInInit = SignInNetwork();

  AuthState _authState;

  String _signInUserName , _signInPassword ;
  String forgotEmail, forgotVerifyCode, forgotPassword, forgotConfirmPassword;

  AuthProvider(){
    this.authState = AuthInitial();
    this.init();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('signInUserName', signInUserName));
    properties.add(StringProperty('signInPassword', signInPassword));
  }

  clearSignIn(){
    signInUserName = '';
    signInPassword = '';
    notifyListeners();
  }
  AuthState get authState => _authState;

  set authState(AuthState value){
    _authState = value;
    notifyListeners();
  }

  String get signInUserName =>_signInUserName;

  set signInUserName(String value){
    _signInUserName = value;
    notifyListeners();
  }

  String get signInPassword =>_signInPassword;

  set signInPassword(String value){
    _signInPassword = value;
    notifyListeners();
  }

  Future<void> checkConnection() async {
    final connection = await DataConnectionChecker().connectionStatus;
    if(connection == DataConnectionStatus.disconnected){
      print("Last results: ${DataConnectionChecker().lastTryResults}");
      this.authState = AuthNetworkError();
    }
  }
  void init() async {
    await this.checkConnection();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value == 1) {
      this.authState = AuthLogined();
    }else{
      await FirebaseMessagingService.getToken();
      NotificationService.dismiss();

      this.authState = AuthLoaded();
    }
  }

  Future<void> checkSignIn() async {
    this.authState = AuthLoading();
    Map<String, String> body = {
      "username": signInUserName.trim(),
      "password": signInPassword.trim(),
      "device_token": await AuthHelper.getDeviceToken(),
      "os_type": Platform.isAndroid ? 'android' : 'ios'
    };
    await signInInit.signIn(body).then((response) async {
       if (response.success == false) {
         await AuthHelper.signOutPreferences();
         this.authState = AuthLoaded();
         if(response.response.toString().contains('Device Token not sent')){
           ShowMessageService.showErrorNotify('Notifications Permission',
               'Please Go to Settings > Notifications > Admin Shop and check turn on "Allow Notifications" and then reload the App.');
         }else
         ShowMessageService.showErrorMsg(response.response);
       }else if (response.success == true) {
        // ProfilePageProvider().setUserDetail(
        //     firstName: response.data["firstname"],
        //     lastName: response.data["lastname"],
        //     email: response.data["username"],
        //     userPhoto: response.data["avatar"],
        //     pitchNum: response.data["pitchdeck"]
        // );
         AuthHelper.savePref(
            loginStatus: 1,
            socialLogin: 0,
            verified: 1,
            userid: response.response["user_id"],
            username: signInUserName.trim(),
            token: response.response["user_token"],
            password: signInPassword.trim()
        );
         this.authState = AuthLogined();
       }
    }).catchError((error) {
      this.authState = AuthLoaded();
      LoggerService.logger.e(error);
    });
  }


  Future<void> signOut(context) async {
    this.authState = AuthLoading();
    clearSignIn();
    Map<String, String> body = {
      "device_token": await AuthHelper.getDeviceToken(),
      "os_type": Platform.isAndroid ? 'android' : 'ios'};
    await signInInit.signIn(body).then((response) async {
        await AuthHelper.signOutPreferences();
        Navigator.pushNamedAndRemoveUntil(context, SignIn.routeName, (route) => false);
        this.authState = AuthLoaded();
    }).catchError((error) {
      this.authState = AuthLoaded();
      LoggerService.logger.e(error);
    });
  }

}
