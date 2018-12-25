//
//  ServiceTypeCollectionViewCell.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/10/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class ServiceTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mcellLbl: UILabel!
    @IBOutlet weak var mBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    func setActive(_ active : Bool = true) {
        let color : UIColor = UIColor.init(red: 246/255.9, green: 123/255.0, blue: 138/255.0, alpha: 1.0)
        if active {
           mBackgroundView.layer.borderColor = color.cgColor
            mBackgroundView.layer.borderWidth = 1
        } else {
            mBackgroundView.layer.borderWidth = 0
        }
        
    }

}
