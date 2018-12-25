//
//  ProvinceCell.swift
//  ThueNha
//
//  Created by Luan Vo on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ProvinceCellDelegate {
  func handleActionTapOnCloseButton()
  func handleActionTapOnSearchProvinceButton()
  func handleActionTapOnProvinceButton()
}

class ProvinceCell: UIView {
  @IBOutlet weak var contentUIView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var searchProvinceButton: UIButton!
  @IBOutlet weak var provinceButton: UIButton!
  @IBOutlet weak var backgroundUIView: UIView!
  var delegate: ProvinceCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    Bundle.main.loadNibNamed("ProvinceCell", owner: self, options: nil)
    addSubview(contentUIView)
    contentUIView.autoPinEdgesToSuperviewEdges()
    provinceButton.backgroundColor = UIColor(red:1.00, green:0.82, blue:0.36, alpha:0.5)
    searchProvinceButton.backgroundColor = UIColor(red:1.00, green:0.82, blue:0.36, alpha:0.3)

    let size = CGSize(width: -1, height: 1)
    backgroundUIView.dropShadow(color: .gray, opacity: 1, offSet: size, radius: 1, scale: true)
    
  }
  @IBAction func closeButtonAction(_ sender: Any) {
    delegate?.handleActionTapOnCloseButton()

  }
  @IBAction func searchProvinceButtonAction(_ sender: Any) {
    delegate?.handleActionTapOnSearchProvinceButton()
  }
  
  @IBAction func provinceButtonAction(_ sender: Any) {
    delegate?.handleActionTapOnProvinceButton()
  }
}

extension UIView {
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    
    layer.cornerRadius = radius
    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
