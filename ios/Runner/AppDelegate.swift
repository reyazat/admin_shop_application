import UIKit
import Flutter
import Firebase
import UserNotifications
import PushKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    /* Commented this because it causes error in awesome notification package
     if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self
    } */
            
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
    let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
          title: "Accept",
          options: UNNotificationActionOptions(rawValue: 0))
    let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
          title: "Decline",
          options: UNNotificationActionOptions(rawValue: 0))
    
    let notificationCat = UNNotificationCategory(
      identifier: "TEST_NOTIFICATION",
      actions: [acceptAction, declineAction],
      intentIdentifiers: [],
      options: .customDismissAction)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.setNotificationCategories([notificationCat])
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
           let userID = userInfo["USER_ID"] as? String ?? "Unknown ID"
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let channel = FlutterMethodChannel(name: "flutter.native/helper",binaryMessenger: controller.binaryMessenger)
           // Perform the task associated with the action.
           switch response.actionIdentifier {
           case "ACCEPT_ACTION":
            
            channel.invokeMethod("foo", arguments: ["action":"accepted", "userID": userID])
              break
                
           case "DECLINE_ACTION":
            channel.invokeMethod("bar", arguments: ["action":"accepted", "userID": userID])
              break
                
           // Handle other actions…
         
           default:
              break
           }
        completionHandler()
    }
}


