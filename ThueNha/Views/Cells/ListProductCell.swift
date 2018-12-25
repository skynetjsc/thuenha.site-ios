//
//  ListProductCell.swift
//  
//
//  Created by Luan Vo on 12/6/18.
//

import UIKit

class ListProductCell: UITableViewCell {
  
  @IBOutlet weak var productTitleLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var backgroundUIView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    productTitleLabel.text = ""
    productTitleLabel.font = nil
    productTitleLabel.font = UIFont.OpenSansSemiBold(fontSize: 17)
    
    dateTimeLabel.text = ""
    dateTimeLabel.font = nil
    dateTimeLabel.font = UIFont.OpenSansRegular(fontSize: 10)
    dateTimeLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    
    addressLabel.text = ""
    addressLabel.font = nil
    addressLabel.font = UIFont.OpenSansRegular(fontSize: 18)
    addressLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    
    amountLabel.text = ""
    amountLabel.font = nil
    amountLabel.font = UIFont.OpenSansRegular(fontSize: 18)
    amountLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    
    backgroundUIView.layer.cornerRadius = CGFloat(5)
    backgroundUIView.layer.borderWidth = 1
    backgroundUIView.layer.borderColor = UIColor(red:1.00, green:0.44, blue:0.35, alpha:1.0).cgColor
    backgroundUIView.clipsToBounds = true
  }
  
  func loadCell(productObject: ProductData) {
    productTitleLabel.text = productObject.title
    dateTimeLabel.text = productObject.date
    addressLabel.text = productObject.address
//    amountLabel.text = productObject.price
    if let priceValue = productObject.price.toFloat() {
       amountLabel.text = formatBalance(digit: priceValue)
    }
  }
}

extension UIFont {
  
  static func OpenSansRegular (fontSize: CGFloat) -> UIFont
  {
    return UIFont(name: "OpenSans-Regular", size: fontSize)!
  }
  
  static func OpenSansSemiBold (fontSize: CGFloat) -> UIFont
  {
    return UIFont(name: "OpenSans-SemiBold", size: fontSize)!
  }
  
  static func OpenSansBold (fontSize: CGFloat) -> UIFont
  {
    return UIFont(name: "OpenSans-Bold", size: fontSize)!
  }
}

//extension String {
//  public func toFloat() -> Float? {
//    return Float.init(self)
//  }
//  
//  public func toDouble() -> Double? {
//    return Double.init(self)
//  }
//  
//  public func toInt() -> Int? {
//    return Int.init(self)
//  }
//}
