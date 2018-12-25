//
//  DeviceInstance.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import SystemConfiguration



let  device = DeviceInstance.sharedInstance()
class DeviceInstance: NSObject {
    
    let screenSize = UIScreen.main.bounds.size
    
    static var instance: DeviceInstance!
    class func sharedInstance() -> DeviceInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? DeviceInstance())
        }
        return self.instance
    }
    
//    class func getCertificate() -> String
//    {
//        let uuid: String = UIDevice.current.identifierForVendor!.uuidString
//        let  vendorId = UIDevice.current.identifierForVendor!.uuidString
//        return (uuid+vendorId).md5()
//    }
    
     func  isConnectedNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else
        {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }


}
