//
//  AppInstance.swift
//  ReBook
//
//  Created by Lâm Phạm on 9/14/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit
import SystemConfiguration

let  appInstance = AppInstance.sharedInstance()

class AppInstance: NSObject {
    
    static var instance: AppInstance!
    class func sharedInstance() -> AppInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? AppInstance())
        }
        return self.instance
    }
    //MARK: - CONSTANT
    let SERVER_DATE_FORMAT = "yyyy/MM/dd'T'HH:mm:ss"
    
    
    //MARK: - FUNCTION
    func checkValidateDate(date: Date) -> Bool {
        var out =  true
        let timeInterval = date.timeIntervalSince1970
        if timeInterval < 0 {
            out = false
        }
        return out
    }
    func isBirthdayValidated(strBirthday: String) -> Bool {
        var out =  true
        if strBirthday == "01/01/0001T00:00:00" {
            out = false
        }
        return out
    }
    func getDateFromStringWithServerFormat(strDate: String) -> Date {
        var output: Date!
        let formatter = DateFormatter()
        formatter.dateFormat = SERVER_DATE_FORMAT
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: strDate) {
            output = date
        }
        return output
    }
    func getStringFromDate(date: Date, withFormat format: String) -> String {
        var output: String!
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        output = formatter.string(from: date)
        return output
    }
    
    func getTimeInterval(fromDate: Date, toDate: Date) -> TimeInterval {
        var output: TimeInterval!
        output = toDate.timeIntervalSince(fromDate)
        return output
    }
    func getStringDateSendToServer(date: Date) -> String {
//        let d = date.addingTimeInterval(25200)
        var str = appInstance.getStringFromDate(date: date, withFormat: "yyyy-MM-dd HH:mm:ss")
        str = str.replacingOccurrences(of: " ", with: "T")
        return str
    }
    func  isConnectedNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else
        {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func getCurrentDate() -> Date {
        return Date().addingTimeInterval(25200)
    }
    func getNibName(controllerName: String) -> String {
        var output = controllerName
        if app.deviceModel == DeviceModel.iPhone5.rawValue {
            output = output + "~iPhone5"
        }
        return output
    }
    
}

