//
//  ForgotViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/5/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotViewController: BaseViewController {

    @IBOutlet weak var mPhoneNumber: UserTextField!
    @IBOutlet weak var mHostUserBtn: UIButton!
    @IBOutlet weak var mUserBtn: UIButton!
    var mSelectedUserType : UserType = .user
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doBack(_ sender: UIButton) {
        self.back()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doSendPassword(_ sender: UIButton) {
        if let phone = mPhoneNumber.text {
            if(!phone.isNumber || phone.length != 10 ) {
                self.alert("Số điện thoại không hợp lệ")
            } else if(self.isConnectedToNetwork()) {
                var hud = MBProgressHUD()
                hud = MBProgressHUD.showAdded(to: self.view, animated:
                    true)
                hud.mode = .indeterminate
                DispatchQueue.global(qos: .background).async {
                    Alamofire.request("http://thuenha.site/api/forget_password.php", method: .post, parameters: ["phone":phone,"type":self.mSelectedUserType.rawValue], encoding: URLEncoding.default).responseJSON { response in
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
                            if(errorId == 200){
                                
                                DispatchQueue.main.async {
                                    hud.hide(animated: true)
                                    let alert = UIAlertController(title: "", message: "Chúng tôi đã gửi mật khẩu về số điện thoại của bạn.\nVui lòng kiểm tra điện thoại và đăng nhập lại!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                                        self.back()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                return
                            } else {
                                DispatchQueue.main.async {
                                    if let message = jsonObj["message"].string {
                                        self.alert(message)
                                    } else {
                                        self.alert("Xin vui lòng thử lại sau!")
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            hud.hide(animated: true)
                        }
                    }
                }
            }
        } else {
            self.alert("Vui lòng nhập số điện thoại")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didTapOutSide(_ sender: UITapGestureRecognizer) {
        if(mPhoneNumber.isFirstResponder) {
            mPhoneNumber.resignFirstResponder()
        }
    }
    
    @IBAction func doChangeUserType(_ sender: UIButton) {
        let senderType : UserType = UserType(rawValue:sender.tag)!
        if( senderType != mSelectedUserType){
            mSelectedUserType = senderType
            
            mUserBtn.isSelected = ( senderType == .user)
            mHostUserBtn.isSelected = ( senderType != .user)
            
        }
        
    }
}
