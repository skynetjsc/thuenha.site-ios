//
//  AppDelegate.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 2018/11/27.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import OneSignal

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let app = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavi : UINavigationController = UINavigationController()
    var main = RootViewController()
    var deviceModel = ""
//    var downView : NCNotificationDownView!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        SocketManager.sharedInstance.connect()
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "9778e1d6-db36-4048-b9cd-e5e25d35369a",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
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
        if(UserManager.user.isLogin()) {
            NetworkManager.shareInstance.apiRefreshLoginData { (data, message, isSuccess) in
                
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func showDownView(text: String) {
//        DispatchQueue.main.async {
//            let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74)
//            self.downView = NCNotificationDownView(frame: frame, content: text, handler: {
//
//            })
//            self.window?.addSubview(self.downView)
//        }
//    }
    
    func push(controller : UIViewController)
    {
        mainNavi.pushViewController(controller, animated: true)
    }
    func pop()
    {
        mainNavi.popViewController(animated: true)
    }
    func popToRootVC(animated: Bool) {
        mainNavi.popToRootViewController(animated: animated)
    }
    
    //MARK: - Function
//    func isOpenFirstTime() -> Bool {
//        var output = true
//        if (userInstance.getObject(forKey: KEY_INTRO_OPENED) != nil) {
//            output = false
//        }
//        return output
//    }
//    func openIntroVC() {
//        self.window?.rootViewController = IntroViewController()
//    }
//    func testVC() {
//        mainNavi.viewControllers = [DetailStatisticsViewController()]
//        mainNavi.setNavigationBarHidden(true, animated: true)
//        self.window?.rootViewController = mainNavi
//    }
//    func openLaunchScreen() {
//        self.window?.rootViewController = LaunchScreenViewController()
//    }
//    func openLoginVC() {
//        self.window?.rootViewController = LoginViewController(nibName: appInstance.getNibName(controllerName: "LoginViewController"), bundle: nil)
//        mainNavi.viewControllers.removeAll()
//        main = MainViewController()
//    }
//    func switchMain() {
//        mainNavi.viewControllers = [main]
//        mainNavi.setNavigationBarHidden(true, animated: true)
//        self.window?.rootViewController = mainNavi
//    }

}

extension AppDelegate {
    
    func navigateToConversation() {
        let conversationVC = ConversationViewController(nibName: "ConversationViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: conversationVC)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
}
