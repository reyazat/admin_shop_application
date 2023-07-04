import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static void init() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'new_order',
          channelName: 'New Order Notification',
          channelDescription: 'Show notification when new order comes',
          importance: NotificationImportance.Max,
          soundSource: 'resource://raw/res_ring',
          playSound: true,
        )
      ],
      debug: true,
    );
  }

  static void show(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'new_order',
        title: title,
        body: body,
      ),
    );
  }

  static void dismiss() {
    AwesomeNotifications().dismissAllNotifications();
  }
}
