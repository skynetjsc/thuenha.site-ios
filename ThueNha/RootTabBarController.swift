//
//  RootTabBarController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/5/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var mLastIndex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        // This block code to attch ListConversationViewController with xib file
        // into UITabBarController's viewControllers instead using storyboard.
        // Please note ListConversationViewController index if going to change to other index.
        var myViewControllers = [UIViewController]()
        var index = 0
        for item in self.viewControllers ?? [] {
            if index == 2 { // ListConversationViewController from xib
                let ListConversationVC = ListConversationViewController(nibName: ListConversationViewController.nibName, bundle: nil)
                let navigationController = UINavigationController(rootViewController: ListConversationVC)
                myViewControllers.append(navigationController)
            } else { // Default ViewController in storyboard
                myViewControllers.append(item)
            }
            index += 1
        }
        self.viewControllers = myViewControllers

        let images: [String] = ["tabbar_home","tabbar_favorite","tabbar_chat","tabbar_user"]
        let titles = ["Trang chủ", "Yêu thích", "Tin nhắn", "Cá nhân"]
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)], for: .selected)
//        self.tabBar.tintColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)
        if let tabbarItems = self.tabBar.items {
            for i in 0..<tabbarItems.count {
                let tabbar = tabbarItems[i]
                let imageName:String = images[i]
                let activeImageName:String = imageName+"_active"
                
                tabbar.image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                tabbar.selectedImage = UIImage(named: activeImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                tabbar.title = titles[i]
            }
        }
    }
    
    func logout () {
        UserManager.user.logout()
        self.back()
    }
    
    func back() {
        self.dismiss(animated: true) {
            self.selectedIndex = 0
        }
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        self.mLastIndex = self.selectedIndex
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }

    func gotoLastIndex () {
        self.selectedIndex = self.mLastIndex
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
