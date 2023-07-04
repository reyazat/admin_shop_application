import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/provider/Auth/AuthState.dart';
import 'package:smartshopadmin/screens/HomeScreen.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/widgets/LoadingWidget.dart';

class SignIn extends StatefulWidget {
  static final String routeName = '/SignIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _key = new GlobalKey<FormState>();
  bool _isPassword = true;

  showHide() {
    print(_isPassword);
    print('_isPassword');
    setState(() {
      _isPassword = !_isPassword;
    });
  }


  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      context.read<AuthProvider>().checkSignIn();
    }
  }

  @override
  void initState() {
    context.read<AuthProvider>().init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<AuthProvider>(
                builder: (context, auth, child){
                  if(auth.authState is AuthLoading || auth.authState is AuthInitial) {
                    return LoadingWidget();
                  }else if(auth.authState is AuthLogined){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
                      });
                      return SizedBox();

                  }else if(auth.authState is AuthLoaded){

                    return _submitForm();

                  }else if(auth.authState is AuthNetworkError){
                    return Center(child: Card(
                      margin: EdgeInsets.all(30.0),
                      elevation: 5,
                      color: MainColors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0,right: 30.0,left: 30.0,bottom: 0.0),
                            child: Text(Constants.noInternet,style: Styles.errorTextStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                Phoenix.rebirth(context);
                              },
                              style: Styles.buttonStyle,
                              child: Text(
                                'Reload',
                                style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),);
                  }else{
                    return SizedBox();
                  }
                },
            ),
          ),
        ],
      ),
    ));
  }


  Widget _entryField({String title, String hint, String field}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 58),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              initialValue : field == "username" ? context.watch<AuthProvider>().signInUserName??'' : context.watch<AuthProvider>().signInPassword??'',
              validator: (e) {
                return field == 'username'
                    ? Utility.isEmpty(e)
                    : Utility.validatePassword(e);
              },
              onSaved: (e) => field == "username" ? context.read<AuthProvider>().signInUserName = e : context.read<AuthProvider>().signInPassword = e,
              obscureText: field == "password" ? _isPassword : false,
              keyboardType: field == "password"
                  ? TextInputType.visiblePassword
                  : TextInputType.name,
              decoration: InputDecoration(
                hintStyle: Styles.textHintStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 70),
                hintText: hint,
                focusedErrorBorder: Styles.inputErrorBorderDecoration,
                focusedBorder: Styles.inputBorderDecoration,
                errorBorder: Styles.inputErrorBorderDecoration,
                enabledBorder: Styles.inputBorderDecoration,
                filled: true,
                fillColor: MainColors.white,
                suffixIcon: field == "password"
                    ? IconButton(
                  onPressed: () {
                    showHide();
                  },
                  icon: Icon(
                    _isPassword ? Icons.visibility_off : Icons.visibility,
                    color: _isPassword
                        ? MainColors.greyLight
                        : MainColors.mainColor,
                    size: MediaQuery.of(context).size.height / 35,
                  ),
                )
                    : null,
              ))
        ],
      ),
    );
  }

  Widget _submitForm() {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: <Widget>[
              _entryField(
                  title: "User Name", hint: "Enter your user name.", field: "username"),
              _entryField(
                  title: "Password",
                  hint: "Enter your Password",
                  field: "password"),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              check();
            },
            style: Styles.buttonStyle,
            child: Text(
              'SignIn',
              style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
            ),
          ),
        ],
      ),
    );
  }
}
