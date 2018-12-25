//
//  UserManagementViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/4/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

enum UserType : Int {
    case user = 1
    case host = 2
}

enum UserManagementType : Int {
    case register = 0
    case login = 1
}

class UserTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.setDefaultFontsStyle()
        self.addLeftPadding()
    }
    
    func setDefaultFontsStyle() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [
            .foregroundColor: UIColor.init(red: 36/255.0, green: 37/255.0, blue: 61/255.0, alpha: 1.0),
            .font: UIFont(name:"OpenSans-Regular",size:17)!
            ])
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        paddingView.backgroundColor = UIColor.clear
        self.leftView = paddingView
        self.leftViewMode = .always
        
        
    }
}

class UserManagementViewController: BaseViewController {

    @IBOutlet weak var mTitleView: UILabel!
    @IBOutlet var mTextFieldCollection: [UserTextField]!
    @IBOutlet weak var mLoginPhoneNumber: UserTextField!
    @IBOutlet weak var mLoginPassword: UserTextField!
    @IBOutlet weak var mSignupPhoneNumber: UserTextField!
    @IBOutlet weak var mHostUserBtn: UIButton!
    @IBOutlet weak var mUserBtn: UIButton!
    
    @IBOutlet weak var mLoginUserBtn: UIButton!
    @IBOutlet weak var mLoginHostBtn: UIButton!
    
    var mSelectedUserType : UserType = .user
    var mManagementType: UserManagementType = .register
    @IBOutlet weak var mSignUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(mManagementType == .login) {
            mTitleView.text = "ĐĂNG NHẬP"
            mSignUpView.isHidden = true
            self.view.sendSubviewToBack(mSignUpView)
//            self.setImageStatesForbutton(mLoginUserBtn)
//            self.setImageStatesForbutton(mLoginHostBtn)
//            mLoginUserBtn.isSelected = true
        } else {
//            self.setImageStatesForbutton(mUserBtn)
//            self.setImageStatesForbutton(mHostUserBtn)
//            mUserBtn.isSelected = true
        }
        
        prefillTestingAccount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserManager.user.isLogin()) {
            self.back()
        }
    }
    
    func setImageStatesForbutton(_ button:UIButton ) {
        button.setImage(UIImage.init(named: "radio"), for: UIControl.State.normal)
        button.setImage(UIImage.init(named: "radio_selected"), for: UIControl.State.selected)
    }
    
    @IBAction func doBack(_ sender: UIButton) {
        self.back()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "userManagementShowPolicy") {
            let termVC = segue.destination as! TermViewController
            termVC.mShowType = .policy
        }
    }

    @IBAction func didTapOutside(_ sender: UITapGestureRecognizer) {
        
        for textfield in mTextFieldCollection {
            if(textfield.isFirstResponder) {
                textfield.resignFirstResponder()
                break
            }
        }
        
    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        var message : String = ""
        if(mLoginPhoneNumber.text?.isEmpty)! {
            message = "Vui lòng nhập Email hoặc số điện thoại"
        } else if (mLoginPassword.text?.isEmpty)! {
            message = "Vui lòng nhập mật khẩu"
        }
        
        if (!message.isEmpty) {
            self.alert(message)
        } else {
            self.showHud()
            let phone : String = self.mLoginPhoneNumber.text!
            let pass : String = self.mLoginPassword.text!
            let type : String = "\(self.mSelectedUserType.rawValue)"
            NetworkManager.shareInstance.apiLogin(phone: phone, password: pass, type: type) { (data, message, isSuccess) in
                DispatchQueue.main.async {
                    self.hideHud()
                    if(isSuccess) {
                        self.back()
                    } else {
                        if message.isEmpty {
                            self.alert("Xin vui lòng thử lại sau!")
                        } else {
                            self.alert(message)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func doForgotPassword(_ sender: UIButton) {
        
        
    }
    
    @IBAction func doSendAuthCode(_ sender: UIButton) {
        var message :String = ""
        if (mSignupPhoneNumber.text?.isEmpty)! {
            message = "Vui lòng nhập số điện thoại!"
        } else if !mSignupPhoneNumber.text!.isNumber ||
            !mSignupPhoneNumber.text!.isPhoneFormat() {
            message = "Vui lòng nhập đúng số điện thoại"
        }
        
        if(!message.isEmpty) {
            self.alert(message)
        } else if(self.isConnectedToNetwork()) {
            var hud = MBProgressHUD()
            hud = MBProgressHUD.showAdded(to: self.view, animated:
                true)
            // Set the custom view mode to show any view.
            hud.mode = .indeterminate
            let phone : String = mSignupPhoneNumber.text!
            DispatchQueue.global(qos: .background).async {
                let url : String = "http://thuenha.site/api/verify_code.php?phone=\(phone)&type=\(self.mSelectedUserType.rawValue)"
                Alamofire.request(url).responseJSON{ response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")                         // response serialization result
                    
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    let jsonObj = JSON(response.result.value!)
                    if let errorId = jsonObj["errorId"].int {
                        if errorId == 200, let data = jsonObj["data"].int {
                            let verifyVC : VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                            verifyVC.mPhoneNumber = phone
                            verifyVC.mVerifyCode = data
                            verifyVC.mUserType = self.mSelectedUserType.rawValue
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(verifyVC, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                if let message = jsonObj["message"].string {
                                    self.alert(message)
                                } else {
                                    self.alert("Xin vui lòng thử lại sau!")
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alert("Xin vui lòng thử lại sau!")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        hud.hide(animated: true)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func doChangeUserType(_ sender: UIButton) {
        let senderType : UserType = UserType(rawValue:sender.tag)!
        if( senderType != mSelectedUserType){
            mSelectedUserType = senderType
            let userBtn: UIButton!
            let hostBtn: UIButton!
            if(mManagementType == .login) {
                userBtn = mLoginUserBtn
                hostBtn = mLoginHostBtn
            }else {
                userBtn = mUserBtn
                hostBtn = mHostUserBtn
            }
            userBtn.isSelected = ( senderType == .user)
            hostBtn.isSelected = ( senderType != .user)
            
        }
        
    }
    
    
}
