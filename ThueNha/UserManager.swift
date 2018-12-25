//
//  UserManager.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserManager {
    static let user = UserManager()
    private var mUserData : JSON!
    private var mAuthen : String!
    private let mUserDefault : UserDefaults = UserDefaults.standard
    private init() {
        
    }
    
    func saveUserData(_ userData: JSON) {
        self.mUserData = userData
        mUserDefault.saveJSON(json: userData, key: "userData")
    }
    
    func saveUserAuthen(_ authen: String) {
        self.mAuthen = authen
        mUserDefault.set(authen, forKey: "authen")
        mUserDefault.synchronize()
    }
    
    func getUserAuthen() -> String {
        return mUserDefault.value(forKey: "authen") as? String ?? ""
    }
    
    func isLogin() -> Bool {
        if (mUserData != nil), let data = mUserData["data"].dictionaryObject {
            return data.index(forKey: "id") != nil
        } else if let _ = UserDefaults.standard.getJSON("userData")["data"].dictionaryObject {
            self.mUserData = UserDefaults.standard.getJSON("userData")
            return self.isLogin()
        }
        return false
    }
    
    func logout() {
        mUserData = nil
        UserDefaults.standard.deleteJSON("userData")
    }
    
    func getData() -> Dictionary<String, Any>? {
        if(self.isLogin()) {
            if let data = mUserData["data"].dictionaryObject {
                return data
            }
        }
        return nil
    }
    
    func id() -> String {
        return self.getString("id")
    }
    
    func name() -> String {
        return self.getString("name")
    }
    
    func email() -> String {
        return self.getString("email")
    }
    
    func  password() -> String {
        return self.getString("password")
    }
    
    func phone() -> String {
        return self.getString("phone")
    }
    
    func address() -> String {
        return self.getString("address")
    }
    
    func account() -> String {
        return self.getString("account")
    }
    
    func date() -> String {
        return self.getString("date")
    }
    
    func birthday() -> String {
        return self.getString("birthday")
    }
    
    func gender() -> String {
        return self.getString("gender")
    }
    
    func  avatar() -> String {
        return self.getString("avatar")
    }
    
    func active() -> Bool {
        let active = self.getString("active")
        return (active == "1")
    }
    
    func type() -> Int {
        let type : String = self.getString("type")
        return Int(type) ?? 0
    }
    
    func noty() -> Int {
        let noty = self.getInt("noty")
        return noty
    }
    
    func message() -> Int {
        let message = self.getInt("message")
        return message
    }
    
    private func getString(_ key : String) -> String {
        if let data = self.getData() {
            if let value : String = data[key] as? String {
                return value
            }
        }
        return ""
    }
    
    private func getInt(_ key: String) -> Int {
        if let data = self.getData() {
            if let value : Int = data[key] as? Int {
                return value
            }
        }
        return 0
    }
    
}


extension UserDefaults {
    
    func saveJSON(json: JSON, key:String) {
        let jsonString = json.rawString()!
        self.setValue(jsonString, forKey: key)
        self.synchronize()
    }
    
    func getJSON(_ key: String)->JSON {
        var p = ""
        if let buildNumber = self.value(forKey: key) as? String {
            p = buildNumber
        }else {
            p = ""
        }
        if  p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                return try! JSON(data: json)
            } else {
                return JSON("nil")
            }
        } else {
            return JSON("nil")
        }
    }
    
    func deleteJSON(_ key: String) {
        self.removeObject(forKey: key)
        self.synchronize()
    }
    
    func setLastSelectedCity(_ city :Dictionary<String , String>) {
        self.setValue(city, forKey: "thuenha_lastSelectedCity")
        self.synchronize()
    }
    
    func setLastSelectedDistrict(_ dis :Dictionary<String , String>) {
        self.setValue(dis, forKey: "thuenha_lastSelectedDistrict")
        self.synchronize()
    }
    
    func getLastSelectedCity() -> Dictionary<String, String>? {
        return self.object(forKey: "thuenha_lastSelectedCity") as? Dictionary<String, String>
    }
    
    func getLastSelectedDistrict() -> Dictionary<String, String>? {
        return self.object(forKey: "thuenha_lastSelectedDistrict") as? Dictionary<String, String>
    }
    
    func deleteLastSelectedCity() {
        self.removeObject(forKey: "thuenha_lastSelectedCity")
    }
    
    func deleteLastSelectedDistrict() {
        self.removeObject(forKey: "thuenha_lastSelectedDistrict")
    }
    
}
