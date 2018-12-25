//
//  UserModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol UserModelProtocol {
    var name: String? { get set }
    var id: String? { get set }
    var avatar: String? { get set }
}

struct UserModel: Codable, UserModelProtocol {
    var name: String?
    var id: String?
    var avatar: String?
    
    
    init() {
        
    }
}

