//
//  SliderCell.swift
//  ThueNha
//
//  Created by Luan Vo on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

protocol SliderCellDelegate {
  func handleActionSelectSlider(minValue: Float, maxValue: Float)
}

class SliderCell: UIView {
  @IBOutlet weak var contentUIView: UIView!
  @IBOutlet weak var amountTitle: UILabel!
  @IBOutlet weak var rangeSlider: RangeSeekSlider!
  @IBOutlet weak var minValueLabel: UILabel!
  @IBOutlet weak var maxValueLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!
  
  var minValueSlider: Float = 0
  var maxValueSlider: Float = 0
  var delegate: SliderCellDelegate?
  override func awakeFromNib() {
    super.awakeFromNib()
    Bundle.main.loadNibNamed("SliderCell", owner: self, options: nil)
    addSubview(contentUIView)
    contentUIView.autoPinEdgesToSuperviewEdges()
    setupView()
    setupSlider()
  }
  
  func setupView() {
    amountTitle.text = "Trong khoảng giá"
    amountTitle.font = nil
    amountTitle.font = UIFont.OpenSansRegular(fontSize: 17)
    
    minValueLabel.text = formatBalance(digit: 500000.0)
    minValueLabel.font = nil
    minValueLabel.font = UIFont.OpenSansRegular(fontSize: 15)
    
    maxValueLabel.text = formatBalance(digit: 20000000.0)
    maxValueLabel.font = nil
    maxValueLabel.font = UIFont.OpenSansRegular(fontSize: 15)
    
    averageLabel.text = "Mức giá trung bình"
    averageLabel.font = nil
    averageLabel.font = UIFont.OpenSansRegular(fontSize: 15)
  }
  
  func setupSlider() {
    rangeSlider.delegate = self
    rangeSlider.minValue = 500000.0
    rangeSlider.maxValue = 20000000.0
    rangeSlider.selectedMinValue = 500000.0
    rangeSlider.selectedMaxValue = 500000.0
    rangeSlider.handleImage = #imageLiteral(resourceName: "slide_oval")
    rangeSlider.selectedHandleDiameterMultiplier = 1.0
    rangeSlider.colorBetweenHandles = UIColor(red:1.00, green:0.44, blue:0.35, alpha:1.0)
    rangeSlider.lineHeight = 5.0
    rangeSlider.numberFormatter.positivePrefix = "$"
    rangeSlider.numberFormatter.positiveSuffix = "M"
  }
}

extension SliderCell: RangeSeekSliderDelegate {
  
  func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
    let averageValue = CGFloat((minValue + maxValue)/2)
//    averageLabel.text = "Mức giá trung bình " + String(format: "%.0f", Double(averageValue)) + " VNĐ"
    minValueSlider = minValue.cgFloatToFloat
    maxValueSlider = maxValue.cgFloatToFloat
    averageLabel.text = "Mức giá trung bình " + formatBalance(digit: averageValue.cgFloatToFloat)
  }
  
  func didStartTouches(in slider: RangeSeekSlider) {
    print("did start touches")
  }
  
  func didEndTouches(in slider: RangeSeekSlider) {
    print("did end touches")
    self.delegate?.handleActionSelectSlider(minValue: minValueSlider, maxValue: maxValueSlider)
  }
}

extension CGFloat {
  var cgFloatToFloat: Float { return Float(self) }
}

func formatBalance(digit: Float) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .currency
  formatter.locale = Locale(identifier: "vi_VN")
  if let formattedTipAmount = formatter.string(from: digit as
    NSNumber) {
    return formattedTipAmount
  }
  return ""
}


