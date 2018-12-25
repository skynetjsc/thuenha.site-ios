//
//  EditUserViewController.swift
//  ThueNha
//
//  Created by Tran Duc Lan on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON
import CropViewController


class EditUserViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mAvatar: UIImageView!
    @IBOutlet weak var mUserName: UILabel!
    @IBOutlet weak var mAddress: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    
    @IBOutlet var mTextFields: [UITextField]!
    
    @IBOutlet weak var mEmailTF: UITextField!
    @IBOutlet weak var mNameTF: UITextField!
    @IBOutlet weak var mPassTF: UITextField!
    @IBOutlet weak var mScrollview: UIScrollView!
    
    @IBOutlet weak var mTempAddress: UIButton!
    
    
    var isLoadTempAddress : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
        if(self.isLoadTempAddress) {
            if let district = UserDefaults.standard.getLastSelectedDistrict() {
                if let city = UserDefaults.standard.getLastSelectedCity() {
                    let dName = district["name"]!
                    let cName = city["name"]!
                    self.mTempAddress.setTitle("\(dName), \(cName)", for: .normal)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cập nhập thông tin"
        configNavigationBar()
        self.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterForKeyboardNotifications()
    }
    
    func loadData() {
        let url = UserManager.user.avatar()
        
        if (url != "") {
            mAvatar.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        } else {
            mAvatar.image = UIImage(named: "thuenha")
        }
        mAvatar.layer.masksToBounds = true
        mAvatar.contentMode = .scaleAspectFill
        mUserName.text = UserManager.user.name()
        mAddress.text = UserManager.user.address()
        mEmail.text = UserManager.user.phone()
        
        mTempAddress.setTitle(UserManager.user.address(), for: .normal)
        mNameTF.text = UserManager.user.name()
        mEmailTF.text = UserManager.user.email()
        
    }
    
    @IBAction func doChangeLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "edit_user_to_address", sender: self)
    }
    
    @IBAction func didTapOutside(_ sender: UITapGestureRecognizer) {
        
        for textfield in mTextFields {
            if(textfield.isFirstResponder) {
                textfield.resignFirstResponder()
                break
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        mScrollview.contentInset = insets
        mScrollview.scrollIndicatorInsets = insets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextField? = mTextFields.first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                mScrollview.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        mScrollview.contentInset = UIEdgeInsets.zero
        mScrollview.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "edit_user_to_address") {
            self.isLoadTempAddress = true
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Chọn Ảnh", message: "Chọn ảnh từ", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh mới", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func presentCropViewController(_ image : UIImage)  {
        
        
        let cropViewController = CropViewController( croppingStyle: CropViewCroppingStyle.circular, image: image)
        cropViewController.delegate = self
        cropViewController.presentAnimatedFrom(self, fromView: self.mAvatar, fromFrame: self.getConvertedAvatarFrameToRootView(), setup: nil, completion: nil)
    }
    
    func getConvertedAvatarFrameToRootView() -> CGRect {
        return self.view.convert(self.mAvatar.frame, to: self.view)
    }
    
    func updateAvatar() {
        
        if let image = self.mAvatar.image!.resizedTo3MB() {
            let imageData : Data = image.pngData()!
            
            self.showHud()
            self.hud?.mode = .determinateHorizontalBar
            self.hud?.progress = 0
            DispatchQueue.global(qos: .background).async {
                NetworkManager.shareInstance.apiUpdateAvatar(imageData: imageData, updateProgress: { (progress: Float) -> (Void) in
                    self.hud?.progress = progress
                }, callBack: { (data, messge, isSuccess) in
                    self.hideHud()
                    self.hud?.mode = .indeterminate
                    if(isSuccess) {
                        NetworkManager.shareInstance.apiRefreshLoginData(callBack: { (data, message, isSuccess) in
                            
                        })
                        self.hideHud()
                        self.hud?.mode = .indeterminate
                        self.hud?.progress = 0
                    } else {
                        self.alert("Vui lòng thử lại sau!")
                    }
                })
            }
        }
        
    }
    
    @IBAction func doUpdate(_ sender: Any) {
        
        if (!self.isValidName()) {
            if(self.mNameTF.text?.isEmpty ?? true) {
                self.alert("Vui lòng nhập họ và tên!")
            } else {
                self.alert("Họ tên không được có ký tự đặc biệt!")
            }
            return
            
        }
        
        
        let email = self.mEmailTF.text ?? ""
        let name = self.mNameTF.text ?? ""
        let address = self.mTempAddress.titleLabel?.text ?? ""
        let password = self.mPassTF.text ?? ""
        
        if(email.count > 0 && !self.isValidEmail()) {
            self.alert("Vui lòng kiểm tra lại Email!")
            return
        }
        
        if(password.count > 0 && password.count < 6) {
            self.alert("Mật khẩu ít nhất 6 ký tự!")
            return
        }
        
        self.showHud()
        
        DispatchQueue.global(qos: .background).async {
            
            NetworkManager.shareInstance.apiUpdateProfile(email, name: name, address: address, password: password, callBack: { (data, message, isSuccess) in
                if(isSuccess) {
                    NetworkManager.shareInstance.apiRefreshLoginData(callBack: { (data, message, isSuccess) in
                        DispatchQueue.main.async {
                            self.loadData()
                            self.alert("Cập nhật thông tin thành công!")
                        }
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        self.loadData()
                        self.alert(message.isEmpty ? "Cập nhật thông tin thất bại!" : message)
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.hideHud()
                }
                
            })
        }
        
    }
    
    func isValidEmail() -> Bool {
        if var email = self.mEmailTF.text {
            email = email.trimmingCharacters(in: .whitespaces)
            self.mEmailTF.text = email
            return email.isValidEmail()
        }
        return false
    }
    
    func isValidName() -> Bool {
        if var name = self.mNameTF.text, name.count > 0 {
            name = name.trimmingCharacters(in: .whitespaces)
            self.mNameTF.text = name
            return name.count <= 50 && name.isValidVietnameseName()
        }
        return false
    }
    
    func isValidAddress() -> Bool {
        if let address = mTempAddress.titleLabel?.text, address.count > 0 {
            return true
        }
        return false
    }
    
    
    
}

extension EditUserViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true) {
            self.presentCropViewController(image)
        }
        
    }
    
}

extension EditUserViewController: UINavigationControllerDelegate {
    
}

extension EditUserViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.mAvatar.image = image
        self.showHud()
        self.dismissWithAnimation(cropViewController) { () -> (Void) in
            self.hideHud()
            self.updateAvatar()
        }
    }
    
    func dismissWithAnimation(_ cropViewController: CropViewController, completion : (() -> (Void))?) {
        cropViewController.dismissAnimatedFrom(self, toView: self.mAvatar, toFrame: self.getConvertedAvatarFrameToRootView(), setup: nil, completion: completion)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.dismissWithAnimation(cropViewController, completion: nil)
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidVietnameseName() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z_ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\\s]+$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
