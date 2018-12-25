//
//  WelcomeViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 2018/11/28.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import QuartzCore

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // appDelegate.navigateToConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        if(UserManager.user.isLogin()) {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func didSelectRegister(_ sender: UIButton) {
        
        NSLog("didSelectRegister")
        self.gotoUserManagementView(isLogin: false)
    }
    
    @IBAction func didSelectLogin
        (_ sender: UIButton) {
        NSLog("didSelectLogin")
        self.gotoUserManagementView(isLogin: true)
        
    }
    
    func gotoUserManagementView(isLogin :Bool) {
        let userManagementVC = self.storyboard?.instantiateViewController(withIdentifier: "UserManagementViewController") as! UserManagementViewController
        if(isLogin) {
            userManagementVC.mManagementType = .login
        }
        self.navigationController?.pushViewController(userManagementVC, animated: true)
    }
    
}
