//
//  CommentTableViewCell.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/23/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var mRedLineLeading: NSLayoutConstraint!
    
    @IBOutlet weak var mRedLine: UIView!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mAvatar: UIImageView!
    @IBOutlet weak var mComment: UILabel!
    
    @IBOutlet weak var mContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(_ name: String,time: String, content : String, avatarURL: String, isAdmin: Bool = false) -> Void {
        self.mName.text = name
        self.mTime.text = time
        self.mAvatar.isHidden = isAdmin
        self.mRedLine.isHidden = !isAdmin
        self.mComment.text = content
        if isAdmin {
            self.mRedLineLeading.constant = 8
            self.mName.textColor = self.mRedLine.backgroundColor
        } else {
            self.mAvatar.sd_setImage(with: URL(string: avatarURL), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
            self.mRedLineLeading.constant = 58
            self.mName.textColor = self.mComment.textColor
            
        }
    }

}