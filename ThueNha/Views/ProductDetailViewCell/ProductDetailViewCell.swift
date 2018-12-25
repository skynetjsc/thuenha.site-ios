//
//  HardHomeViewCollectionCell.swift
//  DVC
//
//  Created by Vinh on 12/13/17.
//  Copyright © 2017 DVC. All rights reserved.
//

import UIKit

class ProductDetailViewCell: UICollectionViewCell {
    @IBOutlet weak var imgUtilityProduct: UIImageView!
    
    @IBOutlet weak var viewContentProduct: UIView!
    @IBOutlet weak var lblTitleUtilityProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContentProduct.layer.borderWidth = 1
        viewContentProduct.layer.cornerRadius = 6
        viewContentProduct.layer.borderColor = "E5E9EF".hexColor().cgColor
    }
    func set(item: UtilityProductDetail) {
        imgUtilityProduct.sd_setImage(with: URL(string: item.img), placeholderImage: UIImage(named: "thuenha"), options: .progressiveDownload, completed: nil)
        lblTitleUtilityProduct.text = item.name
    }

}
