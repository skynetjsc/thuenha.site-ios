//
//  MIDialog.swift
//  ReBook
//
//  Created by Lê Dũng on 9/18/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit


enum MIDialogType
{
    case info
    case warning
    case infoConfirm
    case warningConfirm
    case yellow
    case none
}



class MIDialog: GreenView {

    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var btAccept: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var acceptBlock : (() -> Void)!
    var cancelBlock : (() -> Void)!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainView: UIView!

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
    
    init(title : String,desc : String, type : MIDialogType, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        
        mainView.drawRadius(8)
        lbTitle.text = title
        lbDes.text = desc
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
            case .none: break
        }
    }
    required init(title : String,desc : String, type : MIDialogType, okTitle: String, cancelTitle: String, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        mainView.drawRadius(8)
        lbTitle.text = title
        lbDes.text = desc
        btAccept.setTitle(okTitle, for: .normal)
        btCancel.setTitle(cancelTitle, for: .normal)
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break
        case .yellow: setYellow(); break
            case .none: break
        }
        
    }
    func setYellow() {
        headerView.backgroundColor = template.warningColor ;
        btCancel.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func infoConfirm() {
        btCancel.isHidden = false
        headerView.backgroundColor = template.successColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func warningConfirm() {
        headerView.backgroundColor = template.dangerColor ;
        btCancel.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        alphaView.addGestureRecognizer(tap)
    }
    func infoStyle() {
        headerView.backgroundColor = template.successColor ;
        btCancel.isHidden = true

    }
    
    func warningStyle() {
        headerView.backgroundColor = template.dangerColor ;
        btCancel.isHidden = true
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



extension UIView
{
    

    func dialog(title : String ,desc : String , type : MIDialogType ,acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {
        self.endEditing(true)
        let dialog = MIDialog.init(title: title, desc: desc, type: type, acceptBlock: { () in
            acceptBlock()
        }) { () in
            cancelBlock()
        }
        
        app.window?.rootViewController?.view.addSubview(dialog)
        app.window?.rootViewController?.view.setLayout(dialog)
        dialog.showWithAnimation(animation: true)
    }
    func dialogWithCustomButtonTitle(title : String, desc : String, type : MIDialogType, okTitle: String, cancelTitle: String, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void)) {()
        self.endEditing(true)
        let dialog = MIDialog.init(title: title, desc: desc, type: type, okTitle: okTitle, cancelTitle: cancelTitle, acceptBlock: { () in
            acceptBlock()
        }) { () in
            cancelBlock()
        }
        
        app.window?.rootViewController?.view.addSubview(dialog)
        app.window?.rootViewController?.view.setLayout(dialog)
        dialog.showWithAnimation(animation: true)
    }
}

