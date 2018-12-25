//
//  UIFont+ThueNha.swift
//  ThueNha
//
//  Created by  on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func thueNhaOpenSansRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    class func thueNhaOpenSansBold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
    class func thueNhaOpenSansSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
}
