//
//  NewsCollectionViewCell.swift
//  ThueNha
//
//  Created by Hoang Son on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Kingfisher

enum ProductGridViewType : Int {
    case favourite = 0
    case userPost = 1
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbSizw: UIButton!
    @IBOutlet weak var lbWc: UIButton!
    @IBOutlet weak var lbBed: UIButton!
    @IBOutlet weak var lbView: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mFunctionBtn: UIButton!
    @IBOutlet weak var mSeenCount: UILabel!
    
    var target : Any?
    var selector: Selector?
    var mViewType : ProductGridViewType = .favourite
    var id : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataForCell(mdNew: MDNews, cellType: ProductGridViewType, target: Any, selector: Selector) -> Void {
        self.id = mdNew.id
        for uti in mdNew.arrayUti as! Array<MDUtility> {
            if uti.utiID == "2" {
                self.lbBed.setTitle(uti.utiPosition, for: UIControl.State.normal)
            }
            if uti.utiID == "9" {
                self.lbWc.setTitle(uti.utiPosition, for: UIControl.State.normal)
            }
        }
        
        self.lbSizw.setTitle(String(format: "%@m2", mdNew.area ?? ""), for: UIControl.State.normal)
        self.lbView.text = mdNew.address
        self.lbMoney.text = String(format: "%@đ/tháng", Int(mdNew.price!)!.withCommas())
        self.imgView.contentMode = .scaleToFill
        self.imgView.layer.cornerRadius = 8
        self.imgView.layer.masksToBounds = true
        self.imgView.sd_setImage(with: URL(string: mdNew.avatar!), placeholderImage: UIImage(named: "nhatro"), options: .allowInvalidSSLCertificates, completed: nil)
        
        self.mViewType = cellType
        if mViewType == .favourite {
            mSeenCount.isHidden = true
            mFunctionBtn.setImage(UIImage(named: "red_hearts"), for: .normal)
        } else {
            mSeenCount.isHidden = false
            mFunctionBtn.setImage(UIImage(named: "eye"), for: .normal)
            mSeenCount.text = "\(mdNew.number_seen!)"
        }
        
        self.target = target
        self.selector = selector
    }
    
    @IBAction func doSomething(_ sender: UIButton) {
        if let target = target as? NSObjectProtocol {
            if target.responds(to: self.selector) {
                target.perform(self.selector, with: self.id)
            }
        }
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = Locale(identifier: "vi_VN")
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
