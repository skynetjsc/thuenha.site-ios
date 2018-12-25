//
//  InfoFieldSymbol.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

open class GreenInfoFieldSymbol: GreenView {

    @IBOutlet weak var rightBt: GreenButtonCenter!
    @IBOutlet weak var leftBt: GreenButtonCenter!
    @IBOutlet weak var tfContent: GreenTextField!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomTFContraint: NSLayoutConstraint!
    open var content : String!
    {
        set
        {
            self.tfContent.text  = newValue
        }
        get
        {
            return self.tfContent.text;
        }
    }
    
    
    override open func initStyle()
    {
        super.initStyle()
        tfContent.setStyle(greenDefine.GreenInfoFieldSymbol_TextStyle)
        lineView.backgroundColor = greenDefine.GreenInfoFieldSymbol_LineColor
//        leftBt.view.backgroundColor = greenDefine.GreenInfoFieldSymbol_LeftBackgroundColor
//        rightView.backgroundColor = greenDefine.GreenInfoFieldSymbol_RightBackgroundColor;
        
        self.clipsToBounds = true
        self.layer.cornerRadius = greenDefine.GreenInfoFieldSymbol_Radius;
        
//        tfContent .setValue(greenDefine.GreenInfoFieldSymbol_PlacehoderTextColor, forKeyPath: "_placeholderLabel.textColor")
        

    }
    
    open func setContentStyle(_ style : TextStyle)
    {
        tfContent.setStyle(style)
    }
    
    
    
    
    
    open func setLeft(_ image : UIImage)
    {
        self.leftBt.setImage(image)
    }
    
    open func setRight(_ image : UIImage)
    {
        self.rightBt.setImage(image)
    }
    
    open func set(_ security : Bool)
    {
        tfContent.isSecureTextEntry = security;
    }
    
    open func set(placeholder : String)
    {
        tfContent.placeholder = placeholder;
    }
    
    open func setHidenLine(_ isHiden : Bool)
    {
        lineView.isHidden = isHidden
    }

    open func setPaddingBottom(_ padding : Float)
    {
        bottomTFContraint.constant = CGFloat(padding);
    }
    
    open func setTextColor(_ color : UIColor)
    {
        tfContent.textColor = color;
    }
    
    open func setSecurity(security : Bool)
    {
        tfContent.isSecureTextEntry = security
    }
    
    
}
