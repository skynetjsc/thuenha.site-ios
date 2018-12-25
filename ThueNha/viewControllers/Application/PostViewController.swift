//
//  PostViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/10/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CropViewController
import ImagePicker

enum PostCollectionTag : Int {
    case postServiceType = 1
    case postUtilitiesList = 2
    case postImagesList = 3
}

class ServicesCollecitonViewCell : UICollectionViewCell {
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mBackgroundView: UIView!
    
    func set(title text :String, image imageUrl:String?, active isActive: Bool) {
        
        mLabel.text = text
        if let imageUrl = imageUrl {
            mImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "phongtro"), options:.highPriority, completed: nil)
        }
        var color : UIColor
        if(isActive) {
            color = UIColor(red: 246/255.0, green: 123/255.0, blue: 38/255.0, alpha: 1.0)
        } else {
            color = UIColor(red: 229/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1.0)
        }
        self.mBackgroundView.layer.borderColor = color.cgColor
        
    }
}

class PostImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mBackgroundImage: UIImageView!
    @IBOutlet weak var mRemoveButton: UIButton!
    
    @IBOutlet weak var mRemoveBtn: UIButton!
    var target : BaseViewController?
    var selector : Selector?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mBackgroundImage.layer.masksToBounds = true
        mBackgroundImage.roundCorners(corners: [.allCorners], radius: 8)
    }
    
    func setImage(_ image:UIImage, withTarget target:BaseViewController, withSelector selector : Selector, atIndexPath indexPath : IndexPath) {
        mBackgroundImage.image = image
        self.setTarget(target, withSelector: selector, atIndexPath: indexPath)
    }
    
    func setTarget(_ target:BaseViewController, withSelector selector : Selector, atIndexPath indexPath : IndexPath) {
        self.target = target
        self.selector = selector
        self.indexPath = indexPath
    }
    
    func setImage(_ imageUrl:String!, withTarget target:BaseViewController, withSelector selector : Selector, atIndexPath indexPath : IndexPath) -> Void {
        mBackgroundImage.sd_setImage(with: URL(string:imageUrl.urlEncoded()), placeholderImage: UIImage(named:"thuenha"), options: .highPriority, completed: nil)
        self.setTarget(target, withSelector: selector, atIndexPath: indexPath)
    }
    
    @IBAction func doRemove(_ sender: Any) {
        if let target = self.target {
            if let selector = self.selector {
                if (target.responds(to: selector)) {
                    target.perform(selector, with: indexPath)
                }
            }
        }
    }
}

class PostViewController: BaseViewController {

    //height and bottom layout contraints
    @IBOutlet weak var mUploadButtonBottomPadding: NSLayoutConstraint!

    @IBOutlet weak var mServicesTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var mUtilitiesViewHeight: NSLayoutConstraint!
    
    
    //Textfields
    @IBOutlet weak var mTitleTF: UITextField!
    @IBOutlet weak var mPriceTF: UITextField!
    @IBOutlet weak var mAcreageTF: UITextField!
    @IBOutlet weak var mAddressTF: UITextField!
    @IBOutlet weak var mDescriptionTF: UITextField!
    @IBOutlet weak var mBedroomTF: UITextField!
    @IBOutlet weak var mWCTF: UITextField!
    // textfield collection
    @IBOutlet var mTextFields: [UITextField]!
    
    //labels
    @IBOutlet weak var mCityLbl: UILabel!
    @IBOutlet weak var mDistrictLbl: UILabel!
    
    
    //collection views
    @IBOutlet weak var mSErvicesTypeCollection: UICollectionView!
    @IBOutlet weak var mUtilitiesCollection: UICollectionView!
    @IBOutlet weak var mImagesCollection: UICollectionView!
    
    //store data
    var mServices : Array<Dictionary<String,String>> = []
    var mSelectedService : String = ""
    var mUtilities : Array<Dictionary<String, String>> = []
    var mSelectedUtilities: Array<Int> = []
    var mUploadImages : Array<Any> = []
    var mEditPostData: ProductDetail?
    
    //super scrollview
    @IBOutlet weak var mScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let serviceColumnLayout = ColumnFlowLayout(
            cellsPerRow: 3,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets.zero
        )
        mSErvicesTypeCollection.collectionViewLayout = serviceColumnLayout
        
        let utilitiesColumnLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets.zero
        )
        mUtilitiesCollection.collectionViewLayout = utilitiesColumnLayout
        
        self.configNavigationBar()
        if self.mEditPostData != nil {
            self.setAttributeTitle("Chỉnh sửa bài đăng")
            mTitleTF.text = mEditPostData!.post.title
            mPriceTF.text = mEditPostData?.post.price
            mAcreageTF.text = mEditPostData?.post.area
            mAddressTF.text = mEditPostData?.post.address
            mCityLbl.text = mEditPostData?.city
            mDistrictLbl.text = mEditPostData?.district
            mDescriptionTF.text = mEditPostData?.post.content
            mBedroomTF.text = mEditPostData?.post.number_bed
            mWCTF.text = mEditPostData?.post.number_wc
            self.mUploadImages.removeAll()
            for image in (mEditPostData?.image_test)! {
                self.mUploadImages.append(image)
            }
        }else {
            self.setAttributeTitle("ĐĂNG TIN")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
        
        
        self.showImagesCollection(mUploadImages.count > 0)
        if let district = UserDefaults.standard.getLastSelectedDistrict() {
            let dName = district["name"]!
            mDistrictLbl.text = dName
        }
        
        if let city = UserDefaults.standard.getLastSelectedCity() {
            let cName = city["name"]!
            mCityLbl.text = cName
        }
        self.showHud()
        NetworkManager.shareInstance.apiGetServiceList { (data, message, isSuccess) in
            DispatchQueue.main.async {
                self.hideHud()
            }
            if(isSuccess) {
                if let data = data as? JSON {
                    if var data : Array<Dictionary<String, String>> = data.arrayObject as? Array<Dictionary<String, String>> {
                        data = data.filter(self.removeInactiveItem)
                        self.mServices.removeAll()
                        self.mServices.append(contentsOf: data)
                        DispatchQueue.main.async {
                            self.mSErvicesTypeCollection.reloadData()
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
        self.showHud()
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
                        if(self.mEditPostData != nil) {
                            if let utilites = self.mEditPostData?.utility {
                                for utility in utilites {
                                   if let  index = self.mUtilities.firstIndex(where: { (element) -> Bool in
                                        return (element["id"] == utility.id)
                                   }) {
                                    self.mSelectedUtilities.append(index)
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.mUtilitiesCollection.reloadData()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        mScrollView.contentInset = insets
        mScrollView.scrollIndicatorInsets = insets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextField? = mTextFields.first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                mScrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        mScrollView.contentInset = UIEdgeInsets.zero
        mScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
    @IBAction func doPost(_ sender: Any) {
        if (self.mSelectedService.count < 1) {
            self.alert("Vui lòng chọn 1 loại dịch dụ!")
        } else if (self.mSelectedUtilities.count == 0 ){
            self.alert("Vui lòng chọn ít nhất 1 tiện ích!")
        } else {
            for textField in self.mTextFields {
                if let text = textField.text, text.count > 0 {
                    
                } else {
                    self.alert("Vui lòng điền đầy đủ các trường!")
                    return
                }
            }
            if let city = mCityLbl.text, city.count > 0 {
                if let district = mDistrictLbl.text, district.count > 0 {
                    if(self.mEditPostData != nil) {
                        self.sendPost()
                        return
                    }
                    self.showHud()
                    DispatchQueue.global(qos: .background).async {
                        NetworkManager.shareInstance.apiGetPrice(forService: String(self.mSelectedService)) { (data, message, isSuccess) in
                            DispatchQueue.main.async {
                                self.hideHud()
                            }
                            if(isSuccess) {
                                if let data = data as? JSON {
                                    if var price = data["value"].string {
                                        if(price.isEmpty) {
                                            price = "0"
                                        }
                                        price = (Int(price)?.withCommas())!
                                        let dialog = PopupProductDetailView(postContent: String("\(price)đ"), type: .none, acceptBlock: {
                                            DispatchQueue.main.async {
                                                self.sendPost()
                                            }
                                        }, cancelBlock: {
                                            
                                        })
                                        DispatchQueue.main.async {
                                            app.window?.addSubview(dialog)
                                            app.window?.setLayout(dialog)
                                            dialog.showWithAnimation(animation: true)
                                        }
                                    }
                                }
                            } else {
                                self.alert("Vui lòng thử lại sau!")
                            }
                        }
                    }
                } else {
                    self.alert("Vui lòng chọn Quận!")
                }
            } else {
                self.alert("Vui lòng chọn Thành Phố!")
            }
            
        }
    }
    
    func sendUpdate( title titleText: String, price priceVal : String, withArea area:String, city city_id: String, district district_id: String, address addressText: String, content contentText:String, utility id_utility: Array<Dictionary<String, String>>, bed number_bed: String, wc number_wc: String) -> Void {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiEditPost(post: self.mEditPostData?.post.id ?? "0", service: self.mSelectedService, title: titleText, price: priceVal, withArea: area, city: city_id, district: district_id, address: addressText, content: contentText, utility: id_utility, bed: number_bed, wc: number_wc, callBack: { (data, message, isSuccess) in
                DispatchQueue.main.async {
                    if(isSuccess) {
                        self.alert("Bạn đã cập nhật bài viết thành công!", title: "", handler: { (alert) in
                            self.backAction()
                        })
                    } else {
                        let mess = message.isEmpty ? "Cập nhật thất bại, vui lòng thử lại sau!":message
                        self.alert(mess, title: "", handler: nil)
                        
                    }
                    self.hideHud()
                    
                }
                
            })
        }
    }
    
    func sendPost() -> Void {
        self.showHud()
        
        var utilities: Array<Dictionary<String, String>> = []
        for index in self.mSelectedUtilities {
            utilities.append(self.mUtilities[index])
        }
        let title = self.mTitleTF.text ?? ""
        var price = self.mPriceTF.text ?? ""
        price = price.replacingOccurrences(of: ".", with: "")
        price = price.replacingOccurrences(of: ",", with: "")
        let area = self.mAcreageTF.text ?? ""
        var city: String = "1"
        var district: String = "0"
        if let cityObj = UserDefaults.standard.getLastSelectedCity() {
            city = cityObj["id"]!
        }
        if let districtObj = UserDefaults.standard.getLastSelectedDistrict() {
            district = districtObj["id"]!
        }
        let address = self.mAddressTF.text ?? ""
        let description = self.mDescriptionTF.text ?? ""
        let bed = self.mBedroomTF.text ?? "0"
        let wc = self.mWCTF.text ?? "0"
        
        if (self.mEditPostData != nil) {
            if(self.mUploadImages.contains(where: { (image) -> Bool in
                return image is UIImage
            })) {
                self.hud?.mode = .determinateHorizontalBar
                self.hud?.progress = 0
                DispatchQueue.global(qos: .background).async {
                    NetworkManager.shareInstance.apiUpdateImagePost(self.mEditPostData?.post.id ?? "0", images: self.mUploadImages, updateProgress: { (progress) -> Void? in
                        self.hud?.progress = progress
                    }, callBack: { (data, message, isSuccess) in
                        if(isSuccess) {
                            DispatchQueue.main.async {
                                self.hud?.mode = .indeterminate
                            }
                            self.sendUpdate(title: title, price: price, withArea: area, city: city, district: district, address: address, content: description, utility: utilities, bed: bed, wc: wc)
                            
                        } else {
                            DispatchQueue.main.async {
                                self.alert(message.isEmpty ? "Tải ảnh lên lỗi, Vui lòng thử lại sau!" : message, title: "", handler: { (alert) in
                                    
                                })
                                self.hideHud()
                            }
                        }
                    })
                }
            } else {
                self.sendUpdate(title: title, price: price, withArea: area, city: city, district: district, address: address, content: description, utility: utilities, bed: bed, wc: wc)
            }
            
            return
        }
        self.hud?.mode = .determinateHorizontalBar
        self.hud?.progress = 0
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiPost(service: self.mSelectedService, title: title, price: price, withArea: area, city: city, district: district, address: address, content: description, utility: utilities, images: self.mUploadImages, bed: bed, wc: wc, updateProgress: { (progress: Float) -> (Void) in
                DispatchQueue.main.async {
                    self.hud?.progress = progress
                }
            }, callBack: { (data, message, isSuccess) in
                
                self.hideHud()
                self.hud?.mode = .indeterminate
                self.hud?.progress = 0
                if(isSuccess) {
                    if let data = data as? JSON {
                        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
                        productDetailVC.post_id = data.stringValue
                        self.navigationController?.pushViewController(productDetailVC, animated: true)
                    }
                    
                } else {
                    var mess = "Vui lòng thử lại sau"
                    if(!message.isEmpty) {
                        mess = message
                    }
                    DispatchQueue.main.async {
                        self.alert(mess)
                    }
                }
            })
        }
        
        
    }
    
    @IBAction func didTapOutside(_ sender: UITapGestureRecognizer) {
        
        for textfield in mTextFields {
            if(textfield.isFirstResponder) {
                textfield.resignFirstResponder()
                break
            }
        }
        
    }
    
    @objc func doRemoveImage(atIndex indexPath: IndexPath) {
        let index = indexPath.item
        if(mUploadImages.count > index) {
            if let image = mUploadImages[index] as? Image {
                let dialog = PopupProductDetailView(ConfirmDeleteImageType: .none, acceptBlock: {
                    NetworkManager.shareInstance.apiDeleteImage(image.id, callBack: { (data, message, isSuccess) in
                        if(isSuccess){
                            self.mUploadImages.removeAll(where: { (img) -> Bool in
                                if let img = img as? Image {
                                    return img.id == image.id
                                }
                                return false
                            })
                            DispatchQueue.main.async {
                                self.showImagesCollection(self.mUploadImages.count > 0)
                                self.mImagesCollection.reloadData()
                            }
                        } else {
                            self.alert("Vui lòng thử lại sau!")
                        }
                        
                    })
                }, cancelBlock: {
                    
                })
                DispatchQueue.main.async {
                    app.window?.addSubview(dialog)
                    app.window?.setLayout(dialog)
                    dialog.showWithAnimation(animation: true)
                }
            } else {
                mUploadImages.remove(at: index)
                DispatchQueue.main.async {
                    self.showImagesCollection(self.mUploadImages.count > 0)
                    self.mImagesCollection.reloadData()
                }
            }
            
            
        }
    }
    
    func showImagesCollection(_ isShow: Bool) {
        if(isShow) {
            self.mImagesCollection.isHidden = false
            self.mUploadButtonBottomPadding.constant = 112
        } else {
            self.mImagesCollection.isHidden = true
            self.mUploadButtonBottomPadding.constant = 16
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let limit = 10 - self.mUploadImages.count
        if(limit == 0) {
            self.alert("Vui lòng xoá bớt ảnh đã chọn trước khi chọn thêm ( tối đa 10 ảnh)!")
        } else {
            let configuration = Configuration()
            configuration.doneButtonTitle = "Hoàn thành"
            configuration.cancelButtonTitle = "Huỷ"
            configuration.noImagesTitle = "Không có ảnh"
            configuration.recordLocation = false
            
            let imagePickerController = ImagePickerController(configuration: configuration)
            imagePickerController.delegate = self
            imagePickerController.imageLimit = limit
            present(imagePickerController, animated: true, completion: nil)
        }
        
        
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
//        let actionSheet = UIAlertController(title: "Chọn Ảnh", message: "Chọn ảnh từ", preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh mới", style: .default, handler: { (action:UIAlertAction) in
//
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera
//                self.present(imagePickerController, animated: true, completion: nil)
//            }else{
//                print("Camera not available")
//            }
//
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh", style: .default, handler: { (action:UIAlertAction) in
//            imagePickerController.sourceType = .photoLibrary
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
//
//        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func presentCropViewController(_ image : UIImage)  {
        self.showImagesCollection(true)
        let cropViewController = CropViewController( croppingStyle: CropViewCroppingStyle.default, image: image)
        cropViewController.delegate = self
        cropViewController.presentAnimatedFrom(self, fromView: self.mImagesCollection, fromFrame: self.getConvertedAvatarFrameToRootView(), setup: nil, completion: nil)
    }
    
    func getConvertedAvatarFrameToRootView() -> CGRect {
        return self.view.convert(self.mImagesCollection.frame, to: self.view)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case PostCollectionTag.postServiceType.rawValue:
            let data: Dictionary<String, String> = mServices[indexPath.item]
            self.mSelectedService = data["id"] ?? ""
        case PostCollectionTag.postUtilitiesList.rawValue:
            if(self.mSelectedUtilities.contains(indexPath.item)){
                self.mSelectedUtilities.remove(at: self.mSelectedUtilities.firstIndex(of: indexPath.item)!)
            } else {
                self.mSelectedUtilities.append(indexPath.item)
            }
        default:
            print("nothing to do")
        }
        collectionView.reloadData()
    }
}

extension PostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case PostCollectionTag.postServiceType.rawValue:
            return mServices.count
        case PostCollectionTag.postUtilitiesList.rawValue:
            return mUtilities.count
        case PostCollectionTag.postImagesList.rawValue:
            return mUploadImages.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var utilityImageUrl: String?
        var data: Dictionary<String, String>?
        switch collectionView.tag {
        case PostCollectionTag.postUtilitiesList.rawValue:
            data = mUtilities[indexPath.item]
            utilityImageUrl = data?["img"] ?? nil
            let isActive = self.mSelectedUtilities.contains(indexPath.item)
            return self.dequeueReuableCell(collection: collectionView, for: indexPath, source: data, utility: utilityImageUrl, active: isActive)
            
        case PostCollectionTag.postServiceType.rawValue:
            data = mServices[indexPath.item]
            
            return self.dequeueReuableCell(collection: collectionView, for: indexPath, source: data, utility: nil, active: self.mSelectedService == data?["id"] ?? " ")
        
            
        case PostCollectionTag.postImagesList.rawValue:
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
            if let image = self.mUploadImages[indexPath.item] as? UIImage {
                cell.setImage(image, withTarget: self, withSelector: #selector(self.doRemoveImage), atIndexPath: indexPath)
            }
            if let image = self.mUploadImages[indexPath.item] as? Image {
                cell.setImage(image.img, withTarget: self, withSelector: #selector(self.doRemoveImage), atIndexPath: indexPath)
            }
            
            return cell
        
        default:
            print("nothing to do here")
        }
        let cell = UICollectionViewCell()
        return cell
        
    }
    
    func dequeueReuableCell(collection collectionView:UICollectionView, for indexPath: IndexPath, source data: Dictionary<String, String>?,  utility utilityImageUrl: String?, active isActive: Bool) -> ServicesCollecitonViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollecitonViewCell", for: indexPath) as! ServicesCollecitonViewCell
        if let name = data?["name"] {
            cell.set(title: name, image: utilityImageUrl, active: isActive)
        }
        return cell
    }

}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case PostCollectionTag.postServiceType.rawValue:
             let width = (self.view.frame.size.width - 50 ) / 3
            return CGSize(width: width, height: 40)
        case PostCollectionTag.postUtilitiesList.rawValue:
            let width = (self.view.frame.size.width - 40 ) / 2
            return CGSize(width: width, height: 40)
        case PostCollectionTag.postImagesList.rawValue:
            return CGSize(width: 68, height: 68)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
}

extension PostViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            var txtAfterUpdate = text.replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespaces)
            switch textField.tag {
            case mTitleTF.tag:
                return txtAfterUpdate.count <= 50
            case mPriceTF.tag:
                txtAfterUpdate = txtAfterUpdate.replacingOccurrences(of: ".", with: "")
                txtAfterUpdate = txtAfterUpdate.replacingOccurrences(of: ",", with: "")
                if(txtAfterUpdate.isNumber){
                    txtAfterUpdate = (Int(txtAfterUpdate)?.withCommas())!
                    textField.text = txtAfterUpdate
                    return false
                }
                return txtAfterUpdate.isEmpty || txtAfterUpdate.isNumber
            case mAcreageTF.tag:
                return txtAfterUpdate.isEmpty || txtAfterUpdate.isNumber
            case mAddressTF.tag:
                return true
            case mDescriptionTF.tag:
                return true
            case mBedroomTF.tag:
                return txtAfterUpdate.isEmpty || txtAfterUpdate.isNumber
            case mWCTF.tag:
                return txtAfterUpdate.isEmpty || txtAfterUpdate.isNumber
            default:
                return true
            }
        }
        return true
    }
}

extension PostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true) {
            self.presentCropViewController(image)
        }
        
    }
    
}

extension PostViewController: UINavigationControllerDelegate {
    
}

extension PostViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.mUploadImages.append(image)
        self.dismissWithAnimation(cropViewController) { () -> (Void) in
            self.mImagesCollection.reloadData()
        }
    }
    
    func dismissWithAnimation(_ cropViewController: CropViewController, completion : (() -> (Void))?) {
        cropViewController.dismissAnimatedFrom(self, toView: self.mImagesCollection, toFrame: self.getConvertedAvatarFrameToRootView(), setup: nil, completion: completion)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        if(cancelled) {
            self.showImagesCollection(false)
        }
        self.dismissWithAnimation(cropViewController, completion: nil)
    }
}


extension PostViewController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        var count = 0
        while self.mUploadImages.count < 10, count < images.count {
            self.mUploadImages.append(images[count])
            count = count+1
        }
        imagePicker.dismiss(animated: true) {
            self.mImagesCollection.reloadData()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true) {
            self.mImagesCollection.reloadData()
        }
    }
    
    
}
