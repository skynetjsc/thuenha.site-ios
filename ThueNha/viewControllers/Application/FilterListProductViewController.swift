//
//  FilterListProductViewController.swift
//  ThueNha
//
//  Created by Luan Vo on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD



class FilterListProductViewController: BaseViewController {
  
  @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var mCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var mSlider: SliderCell!
    @IBOutlet var mResetFilterView: UIView!
    @IBOutlet var mResetFilterLbl: UILabel!
    
    let StyleRoomCell: String = "StyleRoomCell"
  let UtilitiesCell: String = "UtilitiesCell"
    
  fileprivate let itemsPerRowStyleRoomCell: CGFloat = 3
  fileprivate let itemsPerRowUtilitiesCell: CGFloat = 2
  fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    
    var resultFilter = [ProductData]()
    var mUtilities : Array<Dictionary<String, String>> = []
    var mSelectedUtilities: Array<Int> = []
    var mUploadImages : Array<UIImage> = []
    var productArray = [ProductData]()
    var serviceName: String!
    var listingVc: ListingProductViewController!
    var mAvgPrice: Float = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.mSlider.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    self.navigationItem.setHidesBackButton(true, animated:true);
    self.setNavigationBackButton()
    
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHud()
        self.setAttributeTitle("Sử dụng bộ lọc")
        NetworkManager.shareInstance.apiGetUtilitiesList { (data, message, isSuccess) in
            DispatchQueue.main.async {
                self.hideHud()
            }
            if(isSuccess) {
                if let data = data as? JSON {
                    if var data : Array<Dictionary<String, String>> = data.arrayObject as? Array<Dictionary<String, String>> {
                        data = data.filter(self.removeInactiveItem)
                        self.mUtilities.removeAll()
                        self.mUtilities.append(contentsOf: data)
                        DispatchQueue.main.async {
                            let height = 20.0 + 50 * CGFloat(self.mUtilities.count / 2)
                            self.mCollectionViewHeight.constant = height

                            self.collectionView.reloadData()
                        }
                    }
                }
            } else {
                var mess: String
                if message.isEmpty {
                    mess = "Vui lòng thử lại sau!"
                } else {
                    mess = message
                }
                self.alert(mess, title: "", handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        
    }
    
    func setNavigationBackButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        button.setImage(UIImage(named: "backDark"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(touchupInsideBack), for: .touchUpInside)
        let leftButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftButton
        
//        let imgRight: UIImage? = #imageLiteral(resourceName: "filter_redo").withRenderingMode(.alwaysOriginal)
//        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//        rightButton.setTitle(" Xoá bộ lọc", for: UIControl.State.normal)
//        rightButton.titleLabel?.font = UIFont.thueNhaOpenSansRegular(size: 14)
//        rightButton.setTitleColor(UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0), for: UIControl.State.normal)
//        rightButton.setImage(imgRight, for: UIControl.State.normal)
//        rightButton.semanticContentAttribute = .forceRightToLeft
//        rightButton.addTarget(self, action: #selector(rightButtonAction), for: UIControl.Event.touchUpInside)
        
        self.mResetFilterView.removeFromSuperview()
        self.mResetFilterLbl.font = UIFont.thueNhaOpenSansRegular(size: 14)
        self.mResetFilterLbl.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)
        
        let rightLogo = UIBarButtonItem(customView: mResetFilterView)
        self.navigationItem.rightBarButtonItem = rightLogo
    }
    
    func handleDataAfterSelectedSlider(minValue: Float, maxValue: Float) {
        resultFilter.removeAll()
        for data in productArray {
            if let priceValue = data.price.toFloat() {
                if priceValue > minValue  && priceValue < maxValue{
                    resultFilter.append(data)
                }
            }
        }
        //    productArray = resultFilter
        print("resultFilter",resultFilter)
    }
    

    
    
    @IBAction func filterButton(_ sender: Any) {
        print("press filter")
        self.listingVc.mAvgPrice = String(format: "%.0f", self.mAvgPrice)
        self.listingVc.mUtilitiesIds = ""
        for i in self.mSelectedUtilities {
            let data = self.mUtilities[i]
            if(self.listingVc.mUtilitiesIds.count > 0) {
                self.listingVc.mUtilitiesIds = self.listingVc.mUtilitiesIds + ","
            }
            self.listingVc.mUtilitiesIds = self.listingVc.mUtilitiesIds + data["id"]!
        }
        self.listingVc.updateData()
        self.backAction()
        
    }
    
    @objc func touchupInsideBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doReset(_ sender: Any) {
        self.rightButtonAction(sender)
    }
    
    @objc func rightButtonAction(_ sender: Any){
        print("press right button")
        self.mSelectedUtilities.removeAll()
        self.collectionView.reloadData()
        self.listingVc.mAvgPrice = ""
        self.listingVc.mUtilitiesIds = ""
        self.listingVc.updateData()
        
    }
    
    
}

extension FilterListProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.mSelectedUtilities.contains(indexPath.item)){
            self.mSelectedUtilities.remove(at: self.mSelectedUtilities.firstIndex(of: indexPath.item)!)
        } else {
            self.mSelectedUtilities.append(indexPath.item)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mUtilities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var utilityImageUrl: String?
        var data: Dictionary<String, String>?
        
        data = self.mUtilities[indexPath.item]
        utilityImageUrl = data?["img"] ?? nil
        
        let isActive = self.mSelectedUtilities.contains(indexPath.item)
        var cell = UICollectionViewCell()
        cell = self.dequeueReuableCell(collection: collectionView, for: indexPath, source: data, utility: utilityImageUrl, active: isActive)

        return cell
    }
    
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = (self.view.frame.size.width - 40 ) / 2
    return CGSize(width: width, height: 40)
   
}
    
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if indexPath.section == 0 {
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleRoomCell, for: indexPath) as! StyleRoomCell
//      return cell
//    } else {
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UtilitiesCell, for: indexPath) as! UtilitiesCell
//      return cell
//    }
//  }
    
    
    func dequeueReuableCell(collection collectionView:UICollectionView, for indexPath: IndexPath, source data: Dictionary<String, String>?,  utility utilityImageUrl: String?, active isActive: Bool) -> ServicesCollecitonViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollecitonViewCell", for: indexPath) as! ServicesCollecitonViewCell
        if let name = data?["name"] {
            cell.set(title: name, image: utilityImageUrl, active: isActive)
        }
        return cell
    }

      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
      }

      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
      }

      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
      }

}


extension FilterListProductViewController : StyleRoomLayoutDelegate {
  
  // 1. Returns the photo height
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return 50
  }
  
}

extension FilterListProductViewController: SliderCellDelegate {
    func handleActionSelectSlider(minValue: Float, maxValue: Float) {
        self.mAvgPrice = Float((minValue + maxValue)/2)
    }
}
