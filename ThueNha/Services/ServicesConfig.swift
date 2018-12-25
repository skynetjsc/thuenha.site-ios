//
//  ServicesConfig.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
let  servicesConfig = ServicesConfig.sharedInstance()


class ServicesConfig: NSObject {
    

    //MARK: - bản thật
    let url = "http://thuenha.site"
    var apiKey = "6GtCRYxF9Sk2qATwfBaTbTT3qcJuBapGgxJvEvh5"
    
    static var instance: ServicesConfig!
    class func sharedInstance() -> ServicesConfig
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ServicesConfig())
        }
        return self.instance
    }
    
}


