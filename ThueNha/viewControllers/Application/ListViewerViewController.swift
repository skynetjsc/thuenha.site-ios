//
//  ListViewerViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/18/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserViewCell: UITableViewCell {
    @IBOutlet weak var mAvatarImage: UIImageView!
    @IBOutlet weak var mUserNameLbl: UILabel!
    @IBOutlet weak var mAddressLbl: UILabel!
    @IBOutlet weak var mPhoneLbl: UILabel!
    
}

class ListViewerViewController: BaseViewController {
    
    @IBOutlet weak var mListUserTbl: UITableView!
    
    var mListUser: Array<Dictionary<String, String>> = []
    var mPostId: String!
    var mControllerType:Int = 1 // 1: view normal , 2 : show at "rent"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configNavigationBar()
        if(self.mControllerType == 1) {
            self.setAttributeTitle("Ai đã xem tin của tôi")
        } else {
            self.setAttributeTitle("Ai đã thuê phòng của bạn?")
        }
        self.showHud()
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiGetListViewer(self.mPostId!, callBack: { (data, message, isSuccess) in
                DispatchQueue.main.async {
                    if(isSuccess) {
                        self.mListUser.removeAll()
                        self.mListUserTbl.reloadData()
                        if let data = data as? JSON {
                            self.mListUser.append(contentsOf:  data.arrayObject as! Array<Dictionary<String, String>>)
                            self.mListUserTbl.reloadData {
                                DispatchQueue.main.async {
                                    self.hideHud()
                                }
                            }
                        }
                        
                    } else {
                        var mess = "Vui lòng thử lại sau!"
                        if !message.isEmpty {
                            mess = message
                        }
                        self.alert(mess)
                    }
                    self.hideHud()
                }
            })
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

}

extension ListViewerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.mControllerType == 2) {
            return self.mListUser.count + 1
        }
        return self.mListUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        
        var data: Dictionary<String, String>?
        if (self.mControllerType == 2 ) {
            if(indexPath.row == 0) {
                data = [:] as Dictionary<String, String>
                data?["name"] = "Khách vãng lai"
                
            } else {
                data = self.mListUser[indexPath.row - 1]
            }
        } else {
            data = self.mListUser[indexPath.row]
        }
        
        cell.mUserNameLbl.text = ""
        if let name = data?["name"] {
            cell.mUserNameLbl.text = name
        }
        
        cell.mPhoneLbl.text = ""
        if let phone = data?["phone"] {
            cell.mPhoneLbl.text = phone
        }
        
        cell.mAddressLbl.text = ""
        if let address = data?["address"] {
            cell.mAddressLbl.text = address
        }
        
        cell.mAvatarImage.image = UIImage(named: "thuenha")
        cell.mAvatarImage.layer.masksToBounds = true
        cell.mAvatarImage.contentMode = .scaleAspectFill
        if let avatarImage = data?["avatar"] {
            cell.mAvatarImage.sd_setImage(with: URL(string: avatarImage.urlEncoded()), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        }
        
        return cell
        
    }
    
    
}

extension ListViewerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(self.mControllerType == 2) {
            self.showHud()
            var data: Dictionary<String, String>?
            if(indexPath.row == 0) {
                data = [:] as Dictionary<String, String>
                
            } else {
                data = self.mListUser[indexPath.row - 1]
            }
                
            DispatchQueue.global(qos: .background).async {
                
                NetworkManager.shareInstance.apiRent(postId: self.mPostId, hostId: UserManager.user.id(), userId: data?["id"] ?? "", callBack: { (data, messge, isSuccess) in
                    if isSuccess {
                        self.hideHud()
                        self.alert("Xác nhận cho thuê thành công!", title: "", handler: { (alert) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        self.hideHud()
                    }
                })
                
            }
        }
    }
}
