//
//  ConversationPhotoMessageCell.swift
//  ThueNha
//
//  Created by Hồng Vũ on 12/16/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SnapKit

class ConversationPhotoMessageCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var borderView: UIView?
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UserManager.user.type() == 1 {
            containerView?.snp.makeConstraints({ (make) in
                make.trailing.equalTo(-10)
            })
        } else if UserManager.user.type() == 2 {
            containerView?.snp.makeConstraints({ (make) in
                make.leading.equalTo(10)
            })
        }
    }

}
