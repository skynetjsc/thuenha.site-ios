//
//  RSAInstance.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/23/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
/*
let  rsaInstance = RSAInstance.sharedInstance()
class RSAInstance: NSObject {
    
    var publicKey   = "RSAServerPublicKey_NCMobileERP"
    var publicTag   = "publicTagRSA_NCMobileERP"
    var privateTag  = "privateTagRSA_NCMobileERP"
    var keySize     = 2048

    var serverModulus       = ""
    var serverExponent      = ""
    var serverRSAPublicKey  = ""
    
    var clientPublicKey     = ""
    var clientId            = ""
    var clientCertificate   = DeviceInstance.getCertificate()
    
    
    
    static var instance: RSAInstance!
    class func sharedInstance() -> RSAInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? RSAInstance())
            self.instance.firstInitialize();
        }
        return self.instance
    }
    
    func firstInitialize()
    {
        clientPublicKey = RsaHelper().createKeyPair(withTag: publicTag, privateTag: privateTag, keySize: keySize)
    }
    
    func generatorIV()->String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd.HHmm"
        return dateFormat.string(from: Date())
    }
    
    func encrypt(content : String) ->String
    {
        return RsaHelper.encrypt(content, modulus: serverModulus, exponent: serverExponent, publicTag: privateTag)
    }
    
    func decrypt(content : String)->String
    {
        return RsaHelper().decrypt(content);
    }
    
    func createAPIKey()->String {
        
        var tokenString = userInstance.loginInfo.TokenString
        tokenString = tokenString + "|" + rsaInstance.generatorIV()
        let tokenStringEncrypt = rsaInstance.encrypt(content: tokenString)
        servicesConfig.apiKey = tokenStringEncrypt + "|" + rsaInstance.clientId
        
        
        return servicesConfig.apiKey
    }

}
*/
