//
//  UIViewController+Extensions.swift
//  AerTrakOperator
//
//  Created by LTD on 11/21/18.
//  Copyright © 2018 Aeris. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIViewController: Nibable {
    
}

extension UIApplication {
    
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
