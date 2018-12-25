//
//  MIDialog.swift
//  ReBook
//
//  Created by Lê Dũng on 9/18/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit






class PopupProductDetailView: GreenView {

    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var btAccept: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var chargeView: UIView!
    @IBOutlet weak var rechagreView: UIView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var confirmDeleteImage: UIView!
    
    @IBOutlet weak var guideLbl: UILabel!
    @IBOutlet weak var transferContentLbl: UILabel!
    
    @IBOutlet weak var noteLbl: UILabel!
    var price = ""
    var acceptBlock : (() -> Void)!
    var cancelBlock : (() -> Void)!
    
    @IBOutlet weak var mainView: UIView!

    
    
    @IBOutlet weak var postViewLbl: UILabel!
    
    
    
    @IBAction func cancel(_ sender: Any) {
        cancelBlock()
        remove()
    }
    
    @objc func remove()
    {
//        removeFromSuperview()
        self.dissmissWithAnimation(animation: true)
    }
    
    @IBAction func accept(_ sender: Any) {
        acceptBlock()
        remove()

    }
    
    init(ConfirmDeleteImageType: MIDialogType, acceptBlock: @escaping (()->Void), cancelBlock: @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        self.chargeView.removeFromSuperview()
        self.rechagreView.removeFromSuperview()
        self.postView.removeFromSuperview()
        
        
        
        switch ConfirmDeleteImageType {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
        case .none: break
        }
    }
    
    init(postContent: String, type: MIDialogType, acceptBlock: @escaping (()->Void), cancelBlock: @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        self.chargeView.removeFromSuperview()
        self.rechagreView.removeFromSuperview()
        self.confirmDeleteImage.removeFromSuperview()
        
        let attributedString = NSMutableAttributedString(string: "Thực hiện đăng tin bạn sẽ mất chi phí \ntối đa \(postContent)/luợt.  Chi phí sẽ đuợc trừ vào\nsố tiền trong tài khoản của bạn.", attributes: [
            .font: UIFont.thueNhaOpenSansRegular(size: 14),
            .foregroundColor: UIColor(white: 95.0 / 255.0, alpha: 1.0)
            ])
        
        attributedString.addAttributes([
            .font: UIFont.thueNhaOpenSansBold(size: 14),
            .foregroundColor: UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
            ], range: (attributedString.string as NSString).range(of: postContent))
        
        attributedString.addAttribute(.font, value: UIFont.thueNhaOpenSansBold(size: 14), range: (attributedString.string as NSString).range(of: "luợt"))
        
        self.postViewLbl.attributedText = attributedString
        
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
        case .none: break
        }
    }
    
    init(transferContent: String, type: MIDialogType, acceptBlock: @escaping (()->Void), cancelBlock: @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        self.chargeView.removeFromSuperview()
        self.postView.removeFromSuperview()
        self.confirmDeleteImage.removeFromSuperview()
        
        let myAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.thueNhaOpenSansBold(size: 12)]
        
        let guideAttributeString = self.guideLbl.attributedText?.mutableCopy() as! NSMutableAttributedString
        
        guideAttributeString.addAttributes(myAttributes, range: (guideAttributeString.string as NSString).range(of: "0611001913170"))
        guideAttributeString.addAttributes(myAttributes, range: (guideAttributeString.string as NSString).range(of: "Nguyễn Mạnh Cường"))
        guideAttributeString.addAttributes(myAttributes, range: (guideAttributeString.string as NSString).range(of: "Ngân hàng Vietcombank chi nhánh Ba Đình"))
        self.guideLbl.attributedText = guideAttributeString
        
        let newAttributeString = NSAttributedString(string: transferContent, attributes: myAttributes)
        transferContentLbl.attributedText = newAttributeString
        
        let noteAttributeString = self.noteLbl.attributedText?.mutableCopy() as! NSMutableAttributedString
        noteAttributeString.addAttributes(myAttributes, range: (noteAttributeString.string as NSString).range(of: "0987875427"))
        
        noteLbl.attributedText = noteAttributeString
        
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
        case .none: break
        }
    }
    
    init(title : String, price : String, type : MIDialogType, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        self.rechagreView.removeFromSuperview()
        self.postView.removeFromSuperview()
        self.confirmDeleteImage.removeFromSuperview()
//        if let priceValue =  {
//            amountLabel.text =
//        }
        self.price = formatBalance(digit: price.toFloat() ?? 0)
        mainView.drawRadius(8)
        lbTitle.text = title
        setAttributeTextLabel()
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
        case .none: break
        }
    }
    required init(title : String,price : String, type : MIDialogType, okTitle: String, cancelTitle: String, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        mainView.drawRadius(8)
        self.price = price
        lbTitle.text = title
        setAttributeTextLabel()
        self.rechagreView.removeFromSuperview()
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
        case .none: break
        }
        
    }
    
    func setAttributeTextLabel(){
        lbDes.text = "Bạn có muốn xem toàn bộ thông tin chi tiết tin đăng này không?. Nếu đồng ý bạn sẽ bị trừ"
        let attrs1 = [NSAttributedString.Key.font : UIFont.init(name:"OpenSans-Regular", size: 14)! , NSAttributedString.Key.foregroundColor : "5F5F5F".hexColor()] as [NSAttributedString.Key : Any]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.init(name:"OpenSans-Bold", size: 14)! , NSAttributedString.Key.foregroundColor : "D0021B".hexColor()] as [NSAttributedString.Key : Any]
        
        let attrs3 = [NSAttributedString.Key.font : UIFont.init(name:"OpenSans-Bold", size: 14)! , NSAttributedString.Key.foregroundColor : "5F5F5F".hexColor()] as [NSAttributedString.Key : Any]
        
        
        
        let attributedString1 = NSMutableAttributedString(string:self.lbDes.text!, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:" \(price)", attributes:attrs2)
        
        let attributedString3 = NSMutableAttributedString(string:"/lượt", attributes:attrs3)
        
        let attributedString4 = NSMutableAttributedString(string:" xem", attributes:attrs1)
        
        attributedString3.append(attributedString4 )
        attributedString2.append(attributedString3)
        attributedString1.append(attributedString2)
        self.lbDes.attributedText = attributedString1

    }
    
    func setYellow() {
        btCancel.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func infoConfirm() {
        btCancel.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func warningConfirm() {
        
        btCancel.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func infoStyle() {
        btCancel.isHidden = true
    }
    
    func warningStyle() {
        btCancel.isHidden = true
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIView
{
    
    func showPopupProductDetail(title : String, price: String , type : MIDialogType ,acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        self.endEditing(true)
        let dialog = PopupProductDetailView.init(title: title, price: price, type: type, acceptBlock: { () in
            acceptBlock()
        }) { () in
            cancelBlock()
        }
        app.window?.addSubview(dialog)
        app.window?.setLayout(dialog)
//        app.window?.bringSubviewToFront(dialog)
        dialog.showWithAnimation(animation: true)
    }
    
    func showPopupRecharge() {
        self.endEditing(true)
        var transferContent = ""
        if(UserManager.user.type() == 1) {
            transferContent.append("NGUOITHUE ")
        } else {
            transferContent.append("CHUNHA ")
        }
        transferContent.append("\(UserManager.user.phone())\n")
        let dialog = PopupProductDetailView.init(transferContent: transferContent, type: .none, acceptBlock: {
            
        }) {
            
        }
        app.window?.addSubview(dialog)
        app.window?.setLayout(dialog)
        //        app.window?.bringSubviewToFront(dialog)
        dialog.showWithAnimation(animation: true)
    }
}
extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    
    
}
