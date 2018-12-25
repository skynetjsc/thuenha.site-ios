//
//  VerifyViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/5/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class VerifyViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var mCodeLblCollection: [UILabel]!
    @IBOutlet weak var mNotificationLbl: UILabel!
    @IBOutlet weak var mCountDownview: UIView!
    @IBOutlet weak var mCountLbl: UILabel!
    @IBOutlet weak var mInput: UserTextField!
    var mCountDownTimer : Timer? = nil
    var mCount : Int = 30
    var mPhoneNumber : String = ""
    var mVerifyCode : Int?
    var mUserType : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for label in mCodeLblCollection {
            label.text = ""
        }
        let attributedString = NSMutableAttributedString(string: "Mã xác thực vừa được gửi đến số điện thoại \(mPhoneNumber). Vui lòng nhập mã.", attributes: [
            .font: UIFont(name: "OpenSans-Regular", size: 18.0)!,
            .foregroundColor: UIColor(white: 95.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "OpenSans-Bold", size: 18.0)!, range: NSRange(location: 43, length: mPhoneNumber.count))
        mNotificationLbl.attributedText = attributedString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startCountDown()
    }
    
    func startCountDown(){
        mCountDownview.isHidden = false
        self.onTick() // reset time label
        self.view.bringSubviewToFront(mCountDownview)
        self.mCountDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTick), userInfo: nil, repeats: true)
    }
    
    @objc func onTick() {
        mCount = mCount - 1
        if(mCount == 0) {
            mCount = 31
            self.mCountDownTimer?.invalidate()
            self.onTock()
        } else {
            mCountLbl.text = String("\(mCount)s")
        }
        
    }
    
    func onTock() {
        mCountDownview.isHidden = true
        self.view.sendSubviewToBack(mCountDownview)
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
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespaces)
            if(txtAfterUpdate.count <= 4 && (txtAfterUpdate.isNumber || txtAfterUpdate.count == 0)) {
                for label in mCodeLblCollection {
                    if(txtAfterUpdate.count > label.tag) {
                        label.text = txtAfterUpdate[label.tag]
                    } else {
                        label.text = ""
                    }
                }
                return true
            }
        }
        return false
    }
    
    @IBAction func doVerification(_ sender: UIButton) {
        if let code = mInput.text, Int(code) == self.mVerifyCode, self.isConnectedToNetwork() {
            var hud = MBProgressHUD()
            hud = MBProgressHUD.showAdded(to: self.view, animated:
                true)
            // Set the custom view mode to show any view.
            hud.mode = .indeterminate
            DispatchQueue.global(qos: .background).async {
                Alamofire.request("http://thuenha.site/api/register.php", method: .post, parameters: ["phone":self.mPhoneNumber, "type":self.mUserType!, "password":self.mVerifyCode!], encoding: URLEncoding.default).responseJSON { response in
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
                    if let errorId = jsonObj["errorId"].int, errorId == 200 {
                        self.doLogin(hud)
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
                    DispatchQueue.main.async {
                        hud.hide(animated: true)
                    }
                    
                }
            }
        } else {
            self.alert("Mã xác thực không chính xác")
        }
    }
    
    @IBAction func doResendVerifyCode(_ sender: UIButton) {
        if(self.isConnectedToNetwork()) {
            DispatchQueue.global(qos: .background).async {
                let url : String = "http://thuenha.site/api/verify_code.php?phone=\(self.mPhoneNumber)&type=\(self.mUserType!)"
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
                            self.mVerifyCode = data
                            DispatchQueue.main.async {
                                self.startCountDown()
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
                    
                    
                    
                }
            }
        }
        
        
        
    }
    
    func doLogin(_ hud : MBProgressHUD) {
        if(self.isConnectedToNetwork()) {
            let url :String = "http://thuenha.site/api/login.php?username=\(self.mPhoneNumber)&password=\(self.mVerifyCode!)&type=\(self.mUserType!)"
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
                    if(errorId == 200){
                        UserManager.user.saveUserData(jsonObj)
                        DispatchQueue.main.async {
                            hud.hide(animated: true)
                            self.back()
                        }
                    } else {
                        //                            var message : String = "Xin vui lòng thử lại!"
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

extension String {
    
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
