import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/coupon/CouponProvider.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsProvider.dart';
import 'package:smartshopadmin/screens/settings/CouponsScreen.dart';
import 'package:smartshopadmin/screens/settings/LoyaltyScreen.dart';
import 'package:smartshopadmin/screens/settings/PrinterScreen.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ConfirmDialogWidget.dart';
import 'package:smartshopadmin/widgets/VerticalMenuWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    context.read<SettingsProvider>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MainColors.subMainColor,
        foregroundColor: MainColors.subMainColor,
        title: Text(
          'Settings',
          style: Styles.textTitleStyle.copyWith(
            fontSize: MediaQuery.of(context).size.height / 40,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fitHeight),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 45,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MainColors.white,
                        border: Border.symmetric(horizontal: BorderSide(color: MainColors.greyLight))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: MainColors.greyLight,
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              color: MainColors.white,
                              size: MediaQuery.of(context).size.height / 15,
                            ),
                            maxRadius: MediaQuery.of(context).size.height / 18,
                            minRadius: 10,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.height / 40),
                          Expanded(
                              child: Text(
                            Constants.welcomeAdmin,
                            style: Styles.textLargeLabStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height / 50,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MainColors.white,
                        border: Border.symmetric(horizontal: BorderSide(color: MainColors.greyLight))),
                    child: Column(
                      children: [
                        VerticalMenuWidget(
                          text: 'Printer',
                          icon: Icon(
                            FontAwesomeIcons.print,
                            color: MainColors.mainColor,
                            size: MediaQuery.of(context).size.height / 35,
                          ),
                          press: () => Navigator.pushNamed(context, Printer.routeName),
                        ),
                        Divider(
                          thickness: 1,
                          endIndent: 35,
                          indent: 35,
                        ),
                        VerticalMenuWidget(
                          text: 'Coupons',
                          icon: Icon(
                            FontAwesomeIcons.tag,
                            color: MainColors.mainColor,
                            size: MediaQuery.of(context).size.height / 35,
                          ),
                          press: () {
                            Navigator.pushNamed(context, Coupons.routeName);
                            context.read<CouponProvider>().getCouponList();
                          },
                        ),
                        Divider(
                          thickness: 1,
                          endIndent: 35,
                          indent: 35,
                        ),
                        VerticalMenuWidget(
                          text: 'Loyalty Codes',
                          icon: Icon(
                            FontAwesomeIcons.gratipay,
                            color: MainColors.mainColor,
                            size: MediaQuery.of(context).size.height / 35,
                          ),
                          press: () {
                            Navigator.pushNamed(context, Loyalty.routeName);
                            context.read<LoyaltyProvider>().getLoyaltyList();
                          },
                        ),
                        Divider(
                          thickness: 1,
                          endIndent: 35,
                          indent: 35,
                        ),
                        if (Platform.isIOS)
                          VerticalMenuWidget(
                            text: 'Fix Short Notification Issue',
                            icon: Icon(
                              FontAwesomeIcons.solidBell,
                              color: MainColors.mainColor,
                              size: MediaQuery.of(context).size.height / 35,
                            ),
                            press: () {
                              ConfirmDialogWidget.show(
                                context,
                                title: 'Fix Short Notification Sound Issue',
                                message: 'If notification sound stops after 5 seconds, you have to fix it manually by changing notification banner style to persistent',
                                yes: Text('Go to Notification Settings'),
                              ).then((value) {
                                if (value) {
                                  AwesomeNotifications().showNotificationConfigPage(channelKey: 'new_order');
                                }
                              });
                            },
                          ),
                        if (Platform.isIOS)
                          Divider(
                            thickness: 1,
                            endIndent: 35,
                            indent: 35,
                          ),
                        VerticalMenuWidget(
                            text: 'Sign Out',
                            icon: Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: MainColors.mainColor,
                              size: MediaQuery.of(context).size.height / 35,
                            ),
                            press: () {
                              ShowMessageService.showLoading();
                              context.read<AuthProvider>().signOut(context);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
