//
//  ListNotificationCell.swift
//  ThueNha
//
//  Created by mai kim tai  on 12/22/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class ListNotificationCell: UITableViewCell {
    
    @IBOutlet weak var notiTitleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var backgroundUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notiTitleLabel.text = ""
        notiTitleLabel.font = nil
        notiTitleLabel.font = UIFont.OpenSansSemiBold(fontSize: 16)
        
        dateTimeLabel.text = ""
        dateTimeLabel.font = nil
        dateTimeLabel.font = UIFont.OpenSansRegular(fontSize: 14)
        dateTimeLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        
        desLabel.text = ""
        desLabel.font = nil
        desLabel.font = UIFont.OpenSansRegular(fontSize: 14)
        desLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        
      
        backgroundUIView.layer.cornerRadius = CGFloat(5)
        backgroundUIView.layer.borderWidth = 1
        backgroundUIView.clipsToBounds = true
    }
    
    func loadCell(notiObject: NotiData) {
        notiTitleLabel.text = notiObject.title
        dateTimeLabel.text = notiObject.date
        desLabel.text = notiObject.content
    }
    
}
