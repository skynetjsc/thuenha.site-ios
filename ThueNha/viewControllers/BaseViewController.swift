//
//  BaseViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import SystemConfiguration

class BaseViewController: UIViewController {
    
    var hud : MBProgressHUD?
    var hudShowCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hudShowCount = 1
        self.hideHud()
    }
    
    func showHud() {
        if(self.hudShowCount == 0) {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
        }
        self.hudShowCount = self.hudShowCount + 1
    }
    
    func hideHud() {
        if(self.hudShowCount > 0) {
            self.hudShowCount = self.hudShowCount - 1
            if (self.hudShowCount == 0) {
                hud?.hide(animated: true)
            }
        }
    }
    
    func alert(_ message: String, title : String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        if(!Thread.isMainThread) {
            DispatchQueue.main.async {
                self.alert(message, title: title, handler: handler)
            }
            return
        }
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertInDevelopmentFeature( handler: ((UIAlertAction) -> Void)? = nil) {
        self.alert("Tính năng này đang trong thời gian phát triển !", handler: handler)
    }
    
    func sorterForFileIDESC(this:Dictionary<String, String>, that: Dictionary<String, String>) -> Bool {
        let thisPosition = Int(this["position"]!) ?? 1
        let thatPosition = Int(that["position"]!) ?? 0
        return thisPosition < thatPosition
    }
    
    func removeInactiveItem(item:Dictionary<String, String>) -> Bool {
        return item["active"] == "1"
    }
    
    func isConnectedToNetwork() -> Bool {
        if(!Reachability.isConnectedToNetwork()) {
            print("Internet Connection not Available!")
            self.alert("Internet Connection not Available!", title:"Alert")
            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func formatBalance(digit: Float) -> String {
        return String(format: "%@đ", Int(digit).withCommas())
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale(identifier: "vi_VN")
//        if let formattedTipAmount = formatter.string(from: digit as
//            NSNumber) {
//            return formattedTipAmount
//        }
//        return ""
    }
    
    func configNavigationBar() {
        let imgBack: UIImage? = #imageLiteral(resourceName: "backDark").withRenderingMode(.alwaysOriginal)
        let logo = UIBarButtonItem(image: imgBack, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = logo
        
    }
    
    func setAttributeTitle(_ title : String) -> Void {
        self.title = title
        self.setAttributeTitle()
    }
    
    func setAttributeTitle() -> Void {
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 17)!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)]
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension String {
    public func toFloat() -> Float? {
        return Float.init(self)
    }
    
    public func toDouble() -> Double? {
        return Double.init(self)
    }
    
    public func toInt() -> Int? {
        return Int.init(self)
    }
    
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    func isPhoneFormat() -> Bool {
        return (self ~= "^0") &&
            (self ~= "^[0-9]{10}$")
    }
    
}

public extension CharacterSet {
    
    public static let urlQueryParameterAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&?"))
    
    public static let urlQueryDenied           = CharacterSet.urlQueryAllowed.inverted()
    public static let urlQueryKeyValueDenied   = CharacterSet.urlQueryParameterAllowed.inverted()
    public static let urlPathDenied            = CharacterSet.urlPathAllowed.inverted()
    public static let urlFragmentDenied        = CharacterSet.urlFragmentAllowed.inverted()
    public static let urlHostDenied            = CharacterSet.urlHostAllowed.inverted()
    
    public static let urlDenied                = CharacterSet.urlQueryDenied
        .union(.urlQueryKeyValueDenied)
        .union(.urlPathDenied)
        .union(.urlFragmentDenied)
        .union(.urlHostDenied)
    
    
    public func inverted() -> CharacterSet {
        var copy = self
        copy.invert()
        return copy
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo3MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 3096.0
        
        while imageSizeKB > 3096 {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 3096.0
        }
        
        return resizingImage
    }
}
