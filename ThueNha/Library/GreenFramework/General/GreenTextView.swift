//
//  GreenTextView.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

 class GreenTextView: UITextView {

    func initStyle()
    {
        self.backgroundColor = UIColor.clear
    }
    
    override  func awakeFromNib() {
        initStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }
    
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initStyle()
    }

    public convenience init()
    {
        self.init(frame: CGRect.init())
    }

}
