
import 'package:shared_preferences/shared_preferences.dart';


class AuthHelper {

  static Future getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("token");
  }
  static Future getDeviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("device_token");
  }

  static Future saveDeviceToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("device_token", token);
  }
  static Future getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userId");
  }
  static savePref({
    int loginStatus,
    int socialLogin,
    int verified,
    String userid,
    String username,
    String password,
    String firstname,
    String lastname,
    String avatar,
    String token}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(loginStatus != null)  preferences.setInt("loginStatus", loginStatus) ;
    if(socialLogin != null)  preferences.setInt("socialLogin", socialLogin) ;
    if(verified != null)  preferences.setInt("verified", verified) ;
    if(userid != null)  preferences.setString("userId", userid) ;
    if(username != null)  preferences.setString("username", username);
    if(password != null)  preferences.setString("password", password);
    if(firstname != null)  preferences.setString("firstname", firstname);
    if(lastname != null)   preferences.setString("lastname", lastname);
    if(avatar != null)  preferences.setString("avatar", avatar);
    if(token != null)  preferences.setString("token", token);
  }

  static signOutPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("loginStatus");
    preferences.remove("socialLogin");
    preferences.remove("userId");
    preferences.remove("firstname");
    preferences.remove("lastname");
    preferences.remove("avatar");
    preferences.remove("token");
  }

}
