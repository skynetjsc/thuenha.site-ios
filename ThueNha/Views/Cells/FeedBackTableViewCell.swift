//
//  FeedBackTableViewCell.swift
//  ThueNha
//
//  Created by Bao Nguyen on 12/22/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class FeedBackTableViewCell: UITableViewCell {
    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mReply: UIButton!
    @IBOutlet weak var mComment: UIButton!
    @IBOutlet weak var mLike: UIButton!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mFeedBack: UILabel!
//    @IBOutlet weak var mCommentTblView: SelftSizingTableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mImage.layer.cornerRadius = 8
        mImage.layer.masksToBounds = true
        let spacing:CGFloat = 5
        let imgLike: UIImage? = #imageLiteral(resourceName: "feedback_like_heart").withRenderingMode(.alwaysOriginal)
        mLike.setImage(imgLike, for: .normal)
        mLike.setTitleColor(UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0), for: UIControl.State.normal)
        mLike.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        mLike.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        let imgComment:UIImage = (UIImage(named: "tabbar_chat")?.withRenderingMode(.alwaysOriginal))!
        mComment.setImage(imgComment, for: .normal)
        mComment.setTitleColor(UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0), for: UIControl.State.normal)
        mComment.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        mComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        mReply.setTitle("Trả lời", for: .normal)
        mReply.setTitleColor(UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0), for: UIControl.State.normal)
        mView.translatesAutoresizingMaskIntoConstraints = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class SelftSizingTableView: UITableView {
    
    var update: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func reloadData() {
        
        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//        self.layoutIfNeeded()
    }
//
//    override func layoutSubviews() {
//        
//        super.layoutSubviews()
//        
//        invalidateIntrinsicContentSize()
//        
//    }
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
            
            
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


