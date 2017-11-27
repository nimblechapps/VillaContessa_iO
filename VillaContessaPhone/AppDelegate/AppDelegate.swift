//
//  AppDelegate.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 2/11/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit
import TwilioVoice
import UserNotifications
import Firebase

protocol UpdateUIDelegate {
    func UpdateUI()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var delegate : UpdateUIDelegate! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NSLog("Twilio Voice Version: %@", TwilioVoice.version())
        self.configureUserNotifications()
        FIRApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if #available(iOS 10.0, *) {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//            let center = UNUserNotificationCenter.current()
//            center.getNotificationSettings(completionHandler: { (settings) in
//                if settings.authorizationStatus == .denied {
//                    UIAlertController().alertControllerWithTitle("Not given Remote notification permission", message: "", okButtonTitle: "OK", okBlockHandler: {
//                    }, viewController: self.window?.rootViewController)
//                }
//            })
        }
        else {
            // Fallback on earlier versions
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.cancelAllLocalNotifications()
//            if UIApplication.shared.isRegisteredForRemoteNotifications {
//                UIAlertController().alertControllerWithTitle("Not given Remote notification permission", message: "", okButtonTitle: "OK", okBlockHandler: {
//                }, viewController: self.window?.rootViewController)
//            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        NSLog("Remote Push Notification Token %@", deviceTokenString)
        registerToken(deviceTokenString)
//        UIAlertController().alertControllerWithTitle(deviceTokenString, message: "", okButtonTitle: "OK", okBlockHandler: {
//        }, viewController: self.window?.rootViewController)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Device token for push notifications: FAIL")
        NSLog("didFailToRegisterForRemoteNotificationsWithError %@", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //if (UIApplication.shared.applicationState == UIApplicationState.active) {
            /*if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let body = alert["body"] as? NSString {
                        if body == "inprogress" {
                            self.delegate.UpdateUI()
                            //UIAlertController().alertControllerWithTitle(body as String, message: "", okButtonTitle: "OK", okBlockHandler: {
                            //}, viewController: self.window?.rootViewController)
                        }
                    }
                }
            }*/
        //}
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        NSLog("Handle push from foreground")
        NSLog("willPresent notification %@", notification.request.content.userInfo)
        /*if notification.request.content.body == "inprogress" {
            self.delegate.UpdateUI()
            //UIAlertController().alertControllerWithTitle(notification.request.content.body, message: "", okButtonTitle: "OK", okBlockHandler: {
            //}, viewController: self.window?.rootViewController)
        }*/
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("Handle push from background or closed")
        NSLog("didReceive response %@", response.notification.request.content.userInfo)
        /*if response.notification.request.content.body == "inprogress" {
            self.delegate.UpdateUI()
            //UIAlertController().alertControllerWithTitle(response.notification.request.content.body, message: "", okButtonTitle: "OK", okBlockHandler: {
            //}, viewController: self.window?.rootViewController)
        }*/
    }
 
    // MARK:- Private Method
    func configureUserNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func registerToken(_ deviceToken: String) {
        var urlString = String(format:"\(baseURLString)\(registerTokenEndpoint)")
        urlString += String(format:"?number=\(User_1.replacingOccurrences(of: "+", with: ""))")
        urlString += String(format:"&content=\(deviceToken)")
        do {
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                NSLog("Push Token: %@", result)
            }
        }
        catch {
            NSLog("Error obtaining push token: %@", error.localizedDescription)
        }
    }
}

