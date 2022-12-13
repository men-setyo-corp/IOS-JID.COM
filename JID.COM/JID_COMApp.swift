//
//  JID_COMApp.swift
//  JID.COM
//
//  Created by Macbook on 06/08/22.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
    
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          
          let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { _, _ in }
          )
      }else{
          let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
      }
      
      application.registerForRemoteNotifications()
      // Messaging Delegate
      Messaging.messaging().delegate = self
      
      Messaging.messaging().token { token, error in
        if let error = error {
          print("Error fetching FCM registration token: \(error)")
        } else if let token = token {
          print("FCM registration token: \(token)")
        }
      }
      
      return true
    }
    
}

@main
struct JID_COMApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            SplashScrean()
        }
    }
}


