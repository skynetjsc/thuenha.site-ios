//
//  FeedBackViewController.swift
//  ThueNha
//
//  Created by Bao Nguyen on 12/22/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire
import SwiftyJSON

class FeedBackViewController: BaseViewController {
    
    @IBOutlet weak var mColorView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    var mFeedbackData:[FeedbackData] = []
    let FeedBack_TableView_tag = 100
    var arrayFeedback:[FeedbackData] = []
    var showCommentCheck:Dictionary<Int, Int> = [:]
    @IBOutlet weak var mRepyView: UIView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var mTExtField: UITextField!
    
    
    @IBOutlet weak var mInputBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var mReplyLbl: UILabel!
    var mReplyId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        self.setNavigationBackButton()
        mTableView.register(UINib(nibName: "FeedBackTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedBackCell")
        mTableView.decelerationRate = .fast
        mTableView.estimatedRowHeight = 162
        mTableView.rowHeight = UITableView.automaticDimension
        mColorView.layer.cornerRadius = 15
        mColorView.layer.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        mTExtField.attributedPlaceholder =
            NSAttributedString(string: "Nhập nội dung", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        if #available(iOS 10.0, *) {
            self.mTableView.refreshControl = refreshControl
        } else {
            self.mTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
        self.setAttributeTitle("Phản hồi")
        self.showHud()
        self.loadData()
    }
    
    @objc func reloadData() -> Void {
        self.showHud()
        self.loadData()
    }
    
    @objc func loadData() -> Void {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiGetListFeedBack(callBack: { (data, message, isSuccess) in
                if(isSuccess) {
                    if let jsonObj = data as? JSON {
                        self.mFeedbackData.removeAll()
                        DispatchQueue.main.async {
                            self.mTableView.reloadData()
                        }
                        if let arr = jsonObj.arrayObject as? Array<Dictionary<String, Any>> {
                            for object in arr {
                                var commentList: Array<FeedbackData> = []
                                if let comments = object["comment"] as? Array<Dictionary<String, Any>> {
                                    for comment in comments {
                                        let com = FeedbackData(id: "", user_id: "", type: "", content: comment["comment"] as? String, response: "", date: comment["date"] as? String, date_response: "", like_feedback: "", active: "", name: comment["name"] as? String, avatar: comment["avatar"] as? String, comment: self.arrayFeedback, is_like: 0)
                                        commentList.append(com)
                                    }
                                }
                                let fbData = FeedbackData(id: object["id"] as? String, user_id: object["user_id"] as? String, type: object["type"] as? String, content: object["content"] as? String, response: object["response"] as? String, date: object["date"] as? String, date_response: object["date_response"] as? String, like_feedback: object["like_feedback"] as? String, active: object["active"] as? String, name: object["name"] as? String, avatar: object["avatar"] as? String, comment: commentList, is_like: object["is_like"] as? Int)
                                self.mFeedbackData.append(fbData)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.mTableView.reloadData()
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
        self.mInputBottom.constant = -kbSize.height
//        let mScrollview = self.mTableView
//        self.mTableView.contentInset = insets
//        self.mTableView.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
//        var aRect = self.view.frame;
//        aRect.size.height -= kbSize.height;
//
//        let activeField: UITextField? = mTextFields.first { $0.isFirstResponder }
//        if let activeField = activeField {
//            if !aRect.contains(activeField.frame.origin) {
//                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
//                mScrollview.setContentOffset(scrollPoint, animated: true)
//            }
//        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        self.mInputBottom.constant = 0
//        self.mTableView.contentInset = UIEdgeInsets.zero
//        self.mTableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func setNavigationBackButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        button.setImage(UIImage(named: "backDark"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(touchupInsideBack), for: .touchUpInside)
        let leftButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftButton

    }
    
    @objc func touchupInsideBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendComment(_ sender: Any) {
        if let content = self.mTExtField.text, content.count > 0 {
            self.showHud()
            if(self.mReplyId.isEmpty) {
                DispatchQueue.global(qos: .background).async {
                    NetworkManager.shareInstance.apiPostFeedBack(content: content, callBack: { (data, message, isSuccess) in
                        if(isSuccess) {
                            self.mTExtField.text = ""
                            self.mTExtField.resignFirstResponder()
                            self.loadData()
                        } else {
                            self.alert(message.count > 0 ? message:"Vui lòng thử lại sau!")
                            self.hideHud()
                        }
                        
                    })
                }
            } else {
                let id = self.mReplyId
                self.removeReply(self)
                DispatchQueue.global(qos: .background).async {
                    NetworkManager.shareInstance.apiCommentFeedBack(id: id, comment: content, callBack: { (data, message, isSuccess) in
                        if(isSuccess) {
                            self.mTExtField.text = ""
                            self.mTExtField.resignFirstResponder()
                            self.removeReply(self)
                            self.loadData()
                        } else {
                            self.alert(message.count > 0 ? message:"Vui lòng thử lại sau!")
                            self.hideHud()
                        }
                    })
                }
            }
            
        }
    }
    
}

extension FeedBackViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension FeedBackViewController:UITableViewDelegate {
    
}

extension FeedBackViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( tableView.tag == FeedBack_TableView_tag) {
            return mFeedbackData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data:FeedbackData = mFeedbackData[indexPath.row]
        
        let cell:FeedBackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeedBackCell", for: indexPath) as! FeedBackTableViewCell
        
        cell.mImage.sd_setImage(with: URL(string: data.avatar ?? ""), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        cell.mLike.setTitle(mFeedbackData[indexPath.row].like_feedback, for: .normal)
        cell.mLike.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        if let is_like = data.is_like {
            if(is_like == 0) {
                cell.mLike.setImage(UIImage(named: "feedback_like_heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                cell.mLike.setImage(UIImage(named: "red_hearts")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        
        cell.mLike.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
        cell.mLike.tag = indexPath.row
        cell.mReply.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        cell.mReply.addTarget(self, action: #selector(replyButtonAction(_:)), for: .touchUpInside)
        cell.mReply.tag = indexPath.row
        var commentCount = data.comment!.count
        if let response = data.response, response.count > 0 {
            commentCount = commentCount + 1
        }
        cell.mComment.setTitle("\(commentCount) Bình luận", for: .normal)
        cell.mComment.isEnabled = commentCount > 0
        cell.mComment.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        cell.mComment.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        cell.mComment.titleLabel?.font = UIFont.thueNhaOpenSansRegular(size: 14)
        cell.mView.removeSubsView()
        if(self.showCommentCheck[indexPath.row] == 1) {
            var lastView:UIView = UIView()
            let superView = lastView
            lastView.translatesAutoresizingMaskIntoConstraints = false
            cell.mView.addSubview(lastView)
            lastView.snp.makeConstraints { (maker) in
                maker.leading.equalTo(cell.mView.snp.leading)
                maker.top.equalTo(cell.mView.snp.top)
                maker.trailing.equalTo(cell.mView.snp.trailing)
                maker.bottom.equalTo(cell.mView.snp.bottom)
            }
            if let response = data.response, response.count > 0 {
                var date = ""
                if let time = data.date_response {
                    date = time
                }
                let adminRes = CommentView.initFromNib() as CommentView
                adminRes.setContent("admin", time: date, content: response, avatarURL: "", isAdmin: true)
                cell.mView.addSubview(adminRes)
                adminRes.snp.makeConstraints { (maker) in
                    maker.leading.equalTo(lastView.snp.leading)
                    maker.top.equalTo(lastView.snp.top)
                    maker.trailing.equalTo(lastView.snp.trailing)
                }
                lastView = adminRes
            }
            
            if let comments = data.comment {
                for data in comments {
                    let commentView = CommentView.initFromNib() as CommentView
                    commentView.setContent(data.name ?? "", time: data.date ?? "", content: data.content ?? "", avatarURL: data.avatar ?? "http://thuenha.site")
                    cell.mView.addSubview(commentView)
                    commentView.snp.makeConstraints { (maker) in
                        maker.leading.equalTo(cell.mView.snp.leading)
                        
                        if(lastView == superView) {
                            maker.top.equalTo(lastView.snp.top)
                        } else {
                            maker.top.equalTo(lastView.snp.bottom)
                        }
                        
                        maker.trailing.equalTo(cell.mView.snp.trailing)
                    }
                    lastView = commentView
                    
                }
            }
            if !lastView.isEqual(superView) {
                lastView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(cell.mView.snp.bottom)
                }
            }
        }
        cell.mName.text = data.name
        cell.mDate.text = data.date
        cell.mFeedBack.text = data.content
        cell.mComment.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    @IBAction func removeReply(_ sender: Any) -> Void {
        self.mRepyView.isHidden = true
        self.mRepyView.superview?.sendSubviewToBack(self.mRepyView)
        self.mReplyLbl.text = "Trả lời "
        self.mReplyId = ""
        self.mTExtField.resignFirstResponder()
    }
    
    @objc func replyButtonAction(_ sender: UIButton){
        let data:FeedbackData = mFeedbackData[sender.tag]
        if let id = data.id {
            self.mRepyView.isHidden = false
            
            self.mReplyLbl.text = "Trả lời "
            if let name = data.name {
                self.mReplyLbl.text = "Trả lời " + name
            }
            self.mReplyLbl.sizeToFit()
            self.mRepyView.superview?.bringSubviewToFront(self.mRepyView)
            self.mReplyId = id
            if !self.mTExtField.isFirstResponder && self.mTExtField.canBecomeFirstResponder {
                self.mTExtField.becomeFirstResponder()
            }
        }
        
        
    }
    
    @objc func likeButtonAction(_ sender: UIButton){
        let index = sender.tag
        var data:FeedbackData = mFeedbackData[index]
        let oldVal = data.is_like
        let newVal = oldVal == 1 ? 0 : 1
        data.is_like = newVal
        mFeedbackData[index] = data
        self.mTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiLikeFeedBack(id: String(data.id!), is_like: String(newVal), callBack: { (response, message, isSuccess) in
                if(!isSuccess ) {
                    data.is_like = oldVal
                    self.mFeedbackData[index] = data
                    DispatchQueue.main.async {
                        self.mTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
                    }
                }
            })
        }
    }
    
    @objc func commentButtonAction(_ sender: UIButton){
        let indexPath = sender.tag
        if let x = self.showCommentCheck[indexPath] {
            self.showCommentCheck.removeValue(forKey: indexPath)
            mTableView.reloadData()
        } else {
            self.showCommentCheck[indexPath] = 1
            mTableView.reloadRows(at: [IndexPath.init(row: indexPath, section: 0)], with: UITableView.RowAnimation.automatic)
        }
        mTableView.reloadData()
        
        print("current row \(sender.tag)")
    }
    
}

public struct FeedbackData {
    public var id:String?
    public var user_id:String?
    public var type:String?
    public var content:String?
    public var response:String?
    public var date:String?
    public var date_response:String?
    public var like_feedback:String?
    public var active:String?
    public var name:String?
    public var avatar:String?
    public var comment:Array<FeedbackData>?
    public var is_like:Int?
}
public struct Comment {
    public var name:String?
    public var comment:String?
    public var date:String?
    public var avatar:String?
}
