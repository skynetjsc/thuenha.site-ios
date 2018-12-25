//
//  UIView+Extension.swift
//  LimeSoftware
//
//  Created by KieuVan on 10/11/16.
//  Copyright © 2016 KieuVan. All rights reserved.
//

import Foundation
import UIKit




let AnyViewTag = 101

public extension UIView
{
    func copyView<T: UIView>() -> T
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    public func addByView(_ view : UIView)
    {
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(self)
    }
    
    public func addByViewWithlAutoSizing(_ view : UIView)
    {
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        view.addSubview(self)
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleLeftMargin,UIView.AutoresizingMask.flexibleRightMargin,UIView.AutoresizingMask.flexibleTopMargin,UIView.AutoresizingMask.flexibleBottomMargin ]
    }
    
    public func removeSubsView()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }

    func setY(y : CGFloat)
    {
        self.frame = CGRect.init(x: self.frame.origin.x, y: y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func getY() ->CGFloat
    {
        return self.frame.origin.y
    }
    func getHeight() ->CGFloat
    {
        return self.frame.size.height
    }
    
    func setHeight(height : CGFloat)
    {
        self.frame.size.height = height
    }

    public func drawRound()
    {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = true;
    }
    
    public func drawRadius(_ radius  : CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true;

        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func drawRadius(_ radius  : CGFloat,color : UIColor , thickness :CGFloat )  {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = thickness
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
    }
    
    
    public func addBorder(_ edges: UIRectEdge, color: UIColor, thickness: CGFloat = 0.5) -> [UIView]{
        var borders = [UIView]()
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
        
    }
    
    
    
    
    func verticalView(views : [UIView])
    {
        var targtIndex : Int = -1 ;
        for   i in  0..<views.count
        {
            let limeUnit  : UIView = views[i]
            limeUnit.frame  = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.addSubview(limeUnit)
            var previousXView : UIView!
            var targetView : UIView!
            
            if(i > 0)
            {
                previousXView   = views[i-1]
            }
            
            if(targtIndex != -1 )
            {
                targetView = views [targtIndex]
            }
            limeUnit.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0))
            
            self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
            if(i == 0 )
            {
                self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0))
            }
            else if (i == views.count - 1)
            {
                self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0))
                
                let verticalSpacing1 = NSLayoutConstraint(item: previousXView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: limeUnit, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([verticalSpacing1])
            }
                
            else
            {
                let verticalSpacing1 = NSLayoutConstraint(item: previousXView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: limeUnit, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([verticalSpacing1])
            }
            if(views.count == 1)
            {
                let widthContrain  = NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([widthContrain])
            }
            
            if(targtIndex != -1 )
            {
                let widthContrain  = NSLayoutConstraint(item: limeUnit, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: targetView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([widthContrain])
                
            }
            if(targtIndex == -1 )
            {
                targtIndex = i ;
            }
        }
    }
    
    
    func setLayout(_ view : UIView) // full layout for sub view
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0))
    }
    
    
    
    
}
