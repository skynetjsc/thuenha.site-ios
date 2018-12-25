//
//  GreenExtention+UIButton.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import Foundation
import UIKit

public enum GreenButtonType
{
    case success
    case info
    case warning
    case danger
}

public extension UIButton
{
    public func setType(_ type : GreenButtonType)
    {
        commonStyle()
        switch type {
        case .success: successType() ; break;
        case .info: infoType() ; break;
        case .danger: dangerType() ; break;
        case .warning: warningType() ; break;
        }
    }
    
    fileprivate func commonStyle()
    {
        self.layer.cornerRadius = CGFloat(greenDefine.GreenButton_Radius);
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.clear.cgColor;
    }
    
    public func setTextStyle(_ style : TextStyle)
    {
       self.titleLabel?.setStyle(style)
    }

    public func infoType()
    {
        self.backgroundColor = greenDefine.GreenButtonInfo_BackgroundColor
        self.setTitleColor(greenDefine.GreenButtonInfo_TitleColor, for: .normal)
    }
    
    public func successType()
    {
        self.backgroundColor = greenDefine.GreenButtonSuccess_BackgroundColor
        self.setTitleColor(greenDefine.GreenButtonSuccess_TitleColor, for: .normal)
        self.layer.cornerRadius = CGFloat(greenDefine.GreenButton_Radius);
        self.clipsToBounds = true;
        


    }
    
    public func warningType()
    {
        self.backgroundColor = greenDefine.GreenButtonWarning_BackgroundColor
        self.setTitleColor(greenDefine.GreenButtonWarning_TitleColor, for: .normal)
    }
    
    public func dangerType()
    {
        self.backgroundColor = greenDefine.GreenButtonDanger_BackgroundColor
        self.setTitleColor(greenDefine.GreenButtonDanger_TitleColor, for: .normal)
    }
    
    public func set(title : String)
    {
        self.setTitle(title, for: .normal)
    }
    
}

open class ButtonSuccess: UIButton {
    override open func awakeFromNib() {
        super.awakeFromNib()
        setType(.success)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setType(.success)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setType(.success)
    }
}

open class ButtonInfo: UIButton {
    override open func awakeFromNib() {
        super.awakeFromNib()
        setType(.info)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setType(.info)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setType(.info)
    }
    
}

open class ButtonDanger: UIButton {
    override open func awakeFromNib() {
        setType(.danger)
        dangerType()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setType(.danger)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setType(.danger)
    }
}

open class ButtonWarning: UIButton {
    override open func awakeFromNib() {
        super.awakeFromNib()
        setType(.warning)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setType(.warning)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setType(.warning)
    }
}

