//
//  TermViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/4/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum TermVCShowType :Int {
    case term = 0
    case policy = 1
}

class TermViewController: BaseViewController {

    var mShowType : TermVCShowType = .term
    @IBOutlet weak var mTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTextView.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.addBackButton()
        var link : String
        if(mShowType == .term) {
            link = "http://thuenha.site/api/term.php"
        } else {
            link = "http://thuenha.site/api/privacy.php"
        }
        if(self.isConnectedToNetwork()) {
            Alamofire.request(link).responseJSON { response in
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
                            if let data = jsonObj["data"].dictionaryObject {
                                let titleString: String = data["title"] as! String
                                self.navigationController?.navigationBar.titleTextAttributes =
                                    [NSAttributedString.Key.foregroundColor: UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0),
                                     NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 18)!]
                                self.navigationItem.title = titleString
                                let content : String = data["content"] as! String
                                self.mTextView.text = content
                            }
                            
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
                
            }
        }
        
        
        
        
    }
    
    func addBackButton() {
        self.navigationItem.leftItemsSupplementBackButton = false
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "backDark"), for: UIControl.State.normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backBtn.addTarget(self, action: #selector(self.doBack(_:)), for: .touchUpInside)
        
        let backView = UIBarButtonItem()
        backView.customView = backBtn
        
        self.navigationItem.leftBarButtonItem = backView
    }
    
    @objc func doBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
