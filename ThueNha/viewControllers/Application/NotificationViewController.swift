//
//  NotificationViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/11/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var listNotiTableView: UITableView!
    
    var mNotifyData:[NotiData] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        self.title = "Thông báo"
        configNavigationBar()
        if #available(iOS 10.0, *) {
            self.listNotiTableView.refreshControl = refreshControl
        } else {
            self.listNotiTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHud()
        self.loadData()
    }

    @objc func reloadData() {
        self.showHud()
        self.loadData()
    }
    
    func loadData() {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiGetListNotification(callBack: { (data, message, isSuccess) in
                if(isSuccess) {
                    if let jsonObj = data as? JSON {
                        self.mNotifyData.removeAll()
                        DispatchQueue.main.async {
                            self.listNotiTableView.reloadData()
                        }
                        if let arr = jsonObj.arrayObject as? Array<Dictionary<String, Any>> {
                            for object in arr {
                                let noti = NotiData.init(id: object["id"] as! String, title: object["title"] as! String, description: object["content"] as! String, datetime: object["date"] as! String, hostRead: object["host_read"] as! Int)
                                self.mNotifyData.append(noti)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.listNotiTableView.reloadData()
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    self.hideHud()
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    func setupTableView() {
        listNotiTableView.dataSource = self
        listNotiTableView.delegate = self
        listNotiTableView.separatorStyle = .none
        listNotiTableView.estimatedRowHeight = 30
        listNotiTableView.rowHeight = UITableView.automaticDimension
        listNotiTableView.tableFooterView = UIView()
        listNotiTableView.register(UINib(nibName: "ListNotificationCell", bundle: nil), forCellReuseIdentifier: "ListNotificationCell")
    }

}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mNotifyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListNotificationCell = listNotiTableView.dequeueReusableCell(withIdentifier: "ListNotificationCell")! as! ListNotificationCell
        if !mNotifyData.isEmpty {
            cell.loadCell(notiObject: mNotifyData[indexPath.row])
        }
        if mNotifyData[indexPath.row].host_read != 1 {
            cell.backgroundUIView.layer.borderColor = UIColor(red:1.00, green:0.44, blue:0.35, alpha:1.0).cgColor
        }
        else{
            cell.backgroundUIView.layer.borderColor = UIColor(red:1.00, green:0.44, blue:0.35, alpha:0).cgColor
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "list_noti_to_noti_detail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_noti_to_noti_detail" {
            let notiDetailViewController = segue.destination as! NotificationDetailViewController
            let indexPath: IndexPath = sender as! IndexPath
            notiDetailViewController.notiDataDetail = mNotifyData[indexPath.row]
            
//            notiDetailViewController.detailTitle = mNotifyData[indexPath.row].title
//            notiDetailViewController.detailDes = mNotifyData[indexPath.row].content
//            notiDetailViewController.detailDate = mNotifyData[indexPath.row].date
            
//            notiDetailViewController.notiDataDetail.append(NotiData(id: mNotifyData[indexPath.row].id,title: mNotifyData[indexPath.row].title,description: mNotifyData[indexPath.row].content,datetime: mNotifyData[indexPath.row].date,hostRead: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

public struct NotiData {
    public var id: String!
    public var title: String!
    public var content: String!
    public var date: String!
    public var host_read: Int!
    
    init(id:String, title: String, description:String, datetime:String, hostRead: Int) {
        self.id = id
        self.title = title
        self.content = description
        self.date = datetime
        self.host_read = hostRead
    }
}
