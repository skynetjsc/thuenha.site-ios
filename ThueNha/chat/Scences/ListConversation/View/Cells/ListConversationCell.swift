//
//  ContactCell.swift
//  ThueNha
//
//  Created by vietdung on 12/7/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class ListConversationCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var lblLastMessage: UILabel?
    @IBOutlet weak var lblTimeLastMessage: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar?.layer.borderWidth = 1.0
        avatar?.layer.masksToBounds = true
        avatar?.layer.borderColor = UIColor.white.cgColor
        if let width = avatar?.frame.size.width {
            avatar?.layer.cornerRadius = width / 2
        }
        avatar?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
