
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/HomeProvider.dart';
import 'package:smartshopadmin/provider/clients/ClientsInfoProvider.dart';
import 'package:smartshopadmin/provider/clients/ClientsProvider.dart';
import 'package:smartshopadmin/provider/coupon/CouponProvider.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyProvider.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrderInfoProvider.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrdersProvider.dart';
import 'package:smartshopadmin/provider/orders/OrderInfoProvider.dart';
import 'package:smartshopadmin/provider/orders/OrdersProvider.dart';
import 'package:smartshopadmin/provider/products/ContactlessProductsProvider.dart';
import 'package:smartshopadmin/provider/products/ProductsProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsProvider.dart';
import 'package:smartshopadmin/screens/ClientsInfoScreen.dart';
import 'package:smartshopadmin/screens/ContactLessOrderInfoScreen.dart';
import 'package:smartshopadmin/screens/HomeScreen.dart';
import 'package:smartshopadmin/screens/OrderInfoScreen.dart';
import 'package:smartshopadmin/screens/auth/SignInScreen.dart';
import 'package:smartshopadmin/screens/settings/CouponsScreen.dart';
import 'package:smartshopadmin/screens/settings/LoyaltyScreen.dart';
import 'package:smartshopadmin/screens/settings/PrinterScreen.dart';
import 'package:smartshopadmin/services/FirebaseNotificationService.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartshopadmin/values/MainColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  FirebaseMessagingService.getPermission();
  FirebaseMessaging.onBackgroundMessage(FirebaseMessagingService.firebaseMessagingBackgroundHandler);
  //lock rotation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
      ChangeNotifierProvider<ClientsProvider>(create: (_) => ClientsProvider()),
      ChangeNotifierProvider<ClientsInfoProvider>(create: (_) => ClientsInfoProvider()),
      ChangeNotifierProvider<OrdersProvider>(create: (_) => OrdersProvider()),
      ChangeNotifierProvider<OrderInfoProvider>(create: (_) => OrderInfoProvider()),
      ChangeNotifierProvider<ContactLessOrdersProvider>(create: (_) => ContactLessOrdersProvider()),
      ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
      ChangeNotifierProvider<ContactLessOrderInfoProvider>(create: (_) => ContactLessOrderInfoProvider()),
      ChangeNotifierProvider<ContactlessProductsProvider>(create: (_) => ContactlessProductsProvider()),
      ChangeNotifierProvider<CouponProvider>(create: (_) => CouponProvider()),
      ChangeNotifierProvider<LoyaltyProvider>(create: (_) => LoyaltyProvider()),
    ], child: Phoenix(child: MyApp())),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    NotificationService.dismiss();
    super.dispose();
  }

  @override
  void initState() {
    // FirebaseMessagingService.getPermission();
    // FirebaseMessagingService.firebaseListener();
    FirebaseMessagingService.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      title: Constants.materialAppTitle,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: MainColors.mainColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: MainColors.mainColor,
        ),
        primaryIconTheme: IconThemeData(color: MainColors.white),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: MainColors.white),
          backgroundColor: MainColors.subMainColor,
          foregroundColor: MainColors.subMainColor,
        ),
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/images/app.png',
        duration: 50,
        screenFunction: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          var value = preferences.getInt("loginStatus");
          return value == 1 ? Home() : SignIn();
        },
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: MainColors.shadow,
        curve: Curves.easeInCirc,
        animationDuration: Duration(milliseconds: 2000),
        splashIconSize: 160.0,
      ),
      routes: {
        SignIn.routeName: (context) => SignIn(),
        Home.routeName: (context) => Home(),
        Printer.routeName: (context) => Printer(),
        Coupons.routeName: (context) => Coupons(),
        Loyalty.routeName: (context) => Loyalty(),
        ClientsInfo.routeName: (context) => ClientsInfo(),
        OrderInfo.routeName: (context) => OrderInfo(),
        ContactLessOrderInfo.routeName: (context) => ContactLessOrderInfo(),
      },
    );
  }
}
