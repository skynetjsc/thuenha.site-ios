//
//  ConversationSendingStatusCollectionViewCell.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class ConversationSendingStatusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var text: NSAttributedString? {
        didSet {
            self.label.attributedText = self.text
        }
    }
}
