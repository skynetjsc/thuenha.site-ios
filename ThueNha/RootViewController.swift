//
//  ViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 2018/11/27.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var rootTabController : RootTabBarController!
    var userManagementNavigation : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UserManager.user.isLogin()) {
            if (self.rootTabController != nil) {
                self.rootTabController = nil
            }
            self.rootTabController = self.storyboard?.instantiateViewController(withIdentifier: "rootTabbar") as? RootTabBarController
            self.present(self.rootTabController, animated: true, completion: nil)
        } else {
            if(self.userManagementNavigation == nil) {
                let welcome = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                self.userManagementNavigation = UINavigationController.init(rootViewController: welcome)
            }
            self.present(self.userManagementNavigation, animated: true, completion: nil)
        }
        
    }

}
