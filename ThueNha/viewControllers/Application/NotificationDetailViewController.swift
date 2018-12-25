//
//  NotificationDetailViewController.swift
//  ThueNha
//
//  Created by mai kim tai  on 12/22/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

class NotificationDetailViewController: BaseViewController {
    
    @IBOutlet weak var detailNotificationView: UIView!
    @IBOutlet weak var detailNotiTitle: UILabel!
    @IBOutlet weak var detailNoTiDescription: UILabel!
    @IBOutlet weak var detailNoTiDate: UILabel!
    
    var notiDataDetail:NotiData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailNotiTitle.text = notiDataDetail.title
        detailNoTiDescription.text = notiDataDetail.content
        detailNoTiDate.text = notiDataDetail.date
        
        detailNotificationView.layer.cornerRadius = CGFloat(13)
        detailNotificationView.layer.borderWidth = 1
        detailNotificationView.layer.borderColor = UIColor(red:239/255, green:239/255, blue:244/255, alpha:1.0).cgColor
        
        configNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiGetListNotificationDetail(id: self.notiDataDetail.id, callBack: { (data, message, isSuccess) in
                if(isSuccess) {
//                    if let jsonObj = data as? JSON {
//
//                        DispatchQueue.main.async {
//
//                        }
//                        if let arr = jsonObj.arrayObject as? Array<Dictionary<String, Any>> {
//                            for object in arr {
//                                let noti = NotiData.init(id: object["id"] as! String, title: object["title"] as! String, description: object["content"] as! String, datetime: object["date"] as! String, hostRead: object["host_read"] as! Int)
//
//                            }
//                        }
//
//                        DispatchQueue.main.async {
//
//                        }
//
//                    }
                }
//                DispatchQueue.main.async {
//                    self.hideHud()
//                }
            })
        }
    }
}

