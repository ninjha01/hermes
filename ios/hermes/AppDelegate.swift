//
//  AppDelegate.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fcmToken: String = "fcmToken not set"
    var deviceToken: String = "deviceToken not set"
    var auth: Auth?
    var databaseRef: DatabaseReference?
    var storageRef: StorageReference?
    let firebaseDateFormatString = "yyyy-MM-dd HH:mm"
    let firebaseDateFormatter = DateFormatter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Firebase Config
        firebaseDateFormatter.dateFormat = firebaseDateFormatString
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.databaseRef = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        //Notification configure
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        registerForPushNotifications()
        //If launched from Notification...
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject] {
            launchAssesment(aps: notification)
        }
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //Push Notification Get Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        self.deviceToken = tokenParts.joined()
        
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(self.deviceToken)")
    }
    
    //Push Notification Error Handling
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func launchAssesment(aps: [String: AnyObject]) {
        //Get viewcontroller from navigation controller
        let rootViewController = window?.rootViewController as! UINavigationController
        let calendarVC = rootViewController.viewControllers[0] as! CalendarViewController
        calendarVC.notificationPayload = aps
        calendarVC.performSegue(withIdentifier: "toAssesment", sender: self)
    }
    
    func application( _ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        launchAssesment(aps: aps)
    }
    
    //Mark: Firebase
    
    // *** User API ***
    func getUserDocument() -> DatabaseReference? {
        let userId = getCurrentUser()?.uid
        if userId != nil {
            return databaseRef?.child("users").child(userId!)
        } else {
            print("Failed to get User Document")
            return nil
        }
    }
    
    func updateUser(valueDict: [String: AnyObject]) {
        guard let userDocument = getUserDocument()
            else {
                print("Failed to update User")
                return
        }
        userDocument.updateChildValues(valueDict)
    }
    
    func logout() {
        do {
            try auth!.signOut()
        } catch {
            print("Failed to log out")
        }
    }
    
    func isLoggedIn() -> Bool {
        return auth?.currentUser != nil
    }
    
    //MARK: User Data
    func getCurrentUser() -> User? {
        guard let user = auth?.currentUser else {
            return nil
        }
        return user
    }
    
    // *** Exercise API ***
    
    func getExerciseDocument() -> DatabaseReference? {
        let userId = getCurrentUser()?.uid
        if userId != nil {
            return databaseRef?.child("exercises")
        } else {
            print("Failed to get User Document")
            return nil
        }
    }
    
    // *** Storage API ***
    func getDownloadURL(path: String) -> NSURL? {
        // Fetch the download URL
        let ref = storageRef!.child(path)
        var downloadUrl: NSURL? = nil
        ref.downloadURL { url, e in
            if url != nil {
                downloadUrl = url as! NSURL
            }
        }
        return downloadUrl
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        self.fcmToken = fcmToken
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        self.updateUser(valueDict: ["fcmToken": self.fcmToken] as [String: AnyObject])
    }
    // [END refresh_token]
}

//Recieve Banner even when app is in foreground
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

