//
//  UserInstance.swift
//  MiBook
//
//  Created by Dũng Lê on 7/31/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit
/*
let  userInstance = UserInstance.sharedInstance()

let KEY_USERNAME = "LOGIN_RESIDE_BOOK_USERNAME"
let KEY_PASSWORD = "LOGIN_RESIDE_BOOK_PASSWORD"
let KEY_BUSINESS_ID = "BUSINESS_ID_BY_USER_"
let KEY_INTRO_OPENED = "RESIDE_BOOK_INTRO_OPENED"

class UserInstance: NSObject {
    
    static var instance: UserInstance!
    var UserName: String = ""
    var dateLogin : Date!
    var selectedBusinessModel: GetListBusinessByUser = GetListBusinessByUser()
    var LstBusinessModel: [GetListBusinessByUser] = []
    var loginInfo: LoginEGovUser!
    var isLogin = false
    var userNameLogin = ""
    var passwordLogin = ""
    
    class func sharedInstance() -> UserInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? UserInstance())
        }
        return self.instance
    }
    
    func isFirstLogin()->Bool
    {
        
      return  userInstance.isLogin
//
//        if((UserDefaults.standard.value(forKey: "IsFirstLogin")) != nil)
//        {
//            return true
//        }
//        else
//        {
//            return false;
//        }
    }
    
    func setIsFirsLogin(isFirstLogin : Bool)
    {
        userInstance.isLogin = isFirstLogin
        
//        if(isFirstLogin)
//        {
//            userInstance.isLogin = isFirstLogin
//            UserDefaults.standard.set(true, forKey: "IsFirstLogin")
//        }
//        else
//        {
//            UserDefaults.standard.set(nil, forKey: "IsFirstLogin")
//        }
    }
    func setObject(object: Any, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    func getObject(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    func getKeyBusinessID(user: String) -> String {
        var output = ""
        output = KEY_BUSINESS_ID + user
        return output
    }
    func isHaveFunction(function: String) -> Bool {
        var isHave = false
        for item in userInstance.loginInfo.LstFunctionModel {
            if function == item.FunctionID {
                isHave = true
            }
        }
        return isHave
    }
}
*/
