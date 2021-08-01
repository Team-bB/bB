//
//  AppDelegate.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var notification: String!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions, completionHandler: { result, _ in
                print(result)
            })
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content
            .userInfo
        
        if let aps = userInfo["aps"] as? NSDictionary, let category = aps["category"] as? String {
            if category == "chat" {
                let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
                if let tabVC = window?.rootViewController as? UITabBarController, tabVC.selectedIndex == 1 {
                    return
                }
            }
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content
            .userInfo
        

        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        if let aps = userInfo["aps"] as? NSDictionary,
           let category = aps["category"] as? String,
           let chatId = userInfo["chat_id"] as? String,
           let senderEmail = userInfo["sender_email"] as? String,
           let senderName = userInfo["sender_name"] as? String {
            if category == "chat" {
                let tabVC = UIStoryboard(name: "MeetingListStoryboard", bundle: nil).instantiateViewController(identifier: "MeetingList") as! UITabBarController
                tabVC.selectedIndex = 1
                window?.rootViewController = tabVC
                
                
                let nextVC = ChatVC(with: senderEmail, id: chatId)
                nextVC.title = senderName
                nextVC.navigationItem.largeTitleDisplayMode = .never

                window?.makeKeyAndVisible()
                if let tabVC = window?.rootViewController as? UITabBarController,
                   let navVC = tabVC.selectedViewController as? UINavigationController {
                    navVC.pushViewController(nextVC, animated: true)
                }
            }
        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken ?? ""))")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // fcm token 저장
        guard let fcmToken = fcmToken else { return }
        
        UserDefaults.standard.setValue(fcmToken, forKey: "device_token")
    }
}
