//
//  HardHomeFooterView.swift
//  DVC
//
//  Created by Vinh on 12/13/17.
//  Copyright © 2017 DVC. All rights reserved.
//

import UIKit
protocol HardHomeFooterViewDelegate {
    func HHDidselectFooterView()
}

class HardHomeFooterView: UICollectionReusableView {
    
    var delegate : HardHomeFooterViewDelegate!
    
    @IBOutlet weak var btnSearchServices: UIButton!
    @IBOutlet weak var imgSearchServices: UIImageView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var heightTitleView: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        
    }
    @IBAction func tappedShowSearchFiles(_ sender: Any) {
        delegate.HHDidselectFooterView()
    }
}

