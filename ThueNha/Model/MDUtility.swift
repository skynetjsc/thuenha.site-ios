//
//  MDUtility.swift
//  ThueNha
//
//  Created by Hoang Son on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class MDUtility: NSObject {
    var utiID : String?
    var utiName : String?
    var utiImage : String?
    var utiAvatar : String?
    var utiContent : String?
    var utiNumber : String?
    var utiDate : String?
    var utiActive : String?
    var utiPosition : String?
    
    override init() {
        super.init()
    }
    init(utiID : String, utiName : String, utiImage : String, utiAvatar : String, utiContent : String, utiNumber : String, utiDate : String, utiActive : String, utiPosition : String) {
        self.utiID = utiID
        self.utiName = utiName
        self.utiImage = utiImage
        self.utiAvatar = utiAvatar
        self.utiContent = utiContent
        self.utiNumber = utiNumber
        self.utiDate = utiDate
        self.utiActive = utiActive
        self.utiPosition = utiPosition
    }
}
