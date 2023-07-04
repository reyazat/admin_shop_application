import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/Auth/AuthHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartshopadmin/provider/HomeProvider.dart';
import 'package:smartshopadmin/provider/orders/OrdersProvider.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Styles.dart';

class FirebaseMessagingService {
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Message data: ${message.messageId}-------opened [Background]');
    if (message.data != null) {
      print('Message data: ${message.messageId}-------get data [Background]');
      NotificationService.show('New Order', 'You have new order');
    }
  }

  static getPermission() async {
    await Firebase.initializeApp().whenComplete(() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      final permit = await messaging.requestPermission(
        alert: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (permit.authorizationStatus == AuthorizationStatus.authorized) {
        firebaseListener();
        getToken();
      }
    });
  }

  static firebaseListener() async {
    await Firebase.initializeApp().whenComplete(() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
          print('Message data: ${message.messageId}-------opened [onMessageOpenedApp]');
          if (message.data != null) {
            print('Message data: ${message.messageId}-------get data [onMessageOpenedApp]');
            Get.context?.read<OrdersProvider>()?.searchOrders();
          }
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          print('Message data: ${message.messageId}-------opened [onMessage]');
          if (message.data != null) {
            print('Message data: ${message.messageId}-------get data [onMessage]');
            Get.context?.read<OrdersProvider>()?.searchOrders();
            NotificationService.show('New Order', 'You have new order');
            if (Get.context?.read<HomeProvider>()?.selectedIndex != 2) {
              ShowMessageService.showNotify(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'New Order',
                      style: Styles.textTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.data['order_id'] != null)
                        Row(
                          children: [
                            Text(
                              'Order Number : ',
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                            Text(
                              message.data['order_id'],
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      if (message.data['shipping_method'] != null)
                        Row(
                          children: [
                            Text(
                              'Delivery : ',
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                            Text(
                              message.data['shipping_method'],
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      if (message.data['total'] != null)
                        Row(
                          children: [
                            Text(
                              'Total : ',
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                            Text(
                              message.data['total'],
                              textAlign: TextAlign.left,
                              style: Styles.messageTextStyle,
                            ),
                          ],
                        ),
                    ],
                  ));
            }
          }
        });

        messaging.onTokenRefresh.listen(saveTokenToDatabase);
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        await getPermission();
        print('User declined or has not accepted permission');
      }
    });
  }

  static getToken() async {
    Firebase.initializeApp().whenComplete(() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await messaging.getToken().then((token) async {
          assert(token != null);
          print("MESSAGING TOKEN: " + token);
          await saveTokenToDatabase(token);
        });
      } else {
        await getPermission();
        print('User declined or has not accepted permission');
        print("MESSAGING TOKEN is null");
      }
    });
  }

  static saveTokenToDatabase(String token) async {
    await AuthHelper.saveDeviceToken(token);
  }
}
