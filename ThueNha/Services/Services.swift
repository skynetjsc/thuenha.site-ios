//
//  Services.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import Alamofire
class APIResponse: Mi
{
    var errorId = 0
    var message = ""
    var data : Any!
    var Error  = true
    var isDisconnected = false
}


let  services = Services.sharedInstance()
class Services: NSObject {
    static var instance: Services!
    class func sharedInstance() -> Services
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? Services())
        }
        return self.instance
    }

    func request(api : APIFunction, method : HTTPMethod, param : Dictionary <String, AnyObject>, success :@escaping ((APIResponse)->Void), failure :@escaping ((APIResponse)->Void))
    {
        
        if appInstance.isConnectedNetwork() == false {
            let error = APIResponse()
            error.Error = true
            error.message = "Vui lòng kiểm tra kết nối mạng"
            error.isDisconnected = true
            failure(error)
            return
        }
        
        weak var weakself = self
        let dataRequest = prepareRequest(api: api, parameter: param)
        
        var headerObject = HTTPHeaders()
        
//        headerObject = ["Content-Type": "application/json", "Accept": "application/json"]
        headerObject = ["Content-Type":"application/x-www-form-urlencoded"]
        
        var encoding : ParameterEncoding = JSONEncoding.default
        
        if(method == .get)
        {
            encoding = URLEncoding.default
        }
        else {
            encoding = URLEncoding.httpBody
        }
        print("=====Request=======")
        print(dataRequest)
        Alamofire.request(dataRequest.0, method: method, parameters: dataRequest.1, encoding: encoding, headers: headerObject)
            .responseJSON { response in
                print("=====response from server=======")
                print(response.result.value as Any)   // result of response serialization
                
                if response.result.value == nil {
                    let error = APIResponse()
                    error.Error = true
                    error.message = "Vui lòng kiểm tra kết nối mạng"
                    error.isDisconnected = true
                    failure(error)
                    return
                }
                let apiResponse = weakself?.processReponse(response: response)
                if (apiResponse?.errorId == 200) {
                    success(apiResponse!)
                }
                else {
                    failure(apiResponse!)
                }
        }
    }
    
    func processReponse(response : DataResponse<Any>) -> APIResponse
    {
        if(response.result.isSuccess)
        {
            return APIResponse.init(dictionary: response.result.value as! NSDictionary)
        }
        else
        {
            return APIResponse.init()
        }
    }
    
    func prepareRequest(api : APIFunction, parameter : Dictionary <String,AnyObject>) -> (String, Parameters)
    {
        var endParameter : Parameters = [:]
        for  (k,v) in  parameter
        {
            endParameter[k] = v
        }
        return (servicesConfig.url.appending(api.rawValue),endParameter)
    }
}
