//
//  ExtensionUIView.swift
//  ReBook
//
//  Created by Lâm Phạm on 9/11/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit

public extension UIView {
    func dropShadow(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    func dropShadowInsec()
    {
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.12;
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func showWithAnimation(animation: Bool) {
        weak var weakself = self
        self.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        self.alpha = 1
        if animation {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                weakself?.alpha = 1.0
                weakself?.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        else {
            weakself?.alpha = 1.0
            weakself?.transform = CGAffineTransform.identity
        }
    }
    
    func dissmissWithAnimation(animation: Bool) {
        weak var weakself = self
        if animation {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                weakself?.alpha = 0
                weakself?.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
            }, completion: { (bool) in
                weakself?.removeFromSuperview()
            })
        }
        else {
            weakself?.alpha = 0
            weakself?.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
            weakself?.removeFromSuperview()
        }
    }

}
