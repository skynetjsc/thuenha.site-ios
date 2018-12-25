//
//  Utility.swift
//  ThueNha
//
//  Created by Vinh on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
@objcMembers
/*
 
 "utility": [
 {
 "id": "3",
 "name": "Điều hòa",
 "position": "3",
 "img": "http://thuenha.site/uploads/utility/air-conditioner.png",
 "content": "C\\Users\\DuongKK\\Downloads\\svgtopng",
 "date": "2018-11-17 21:28:16",
 "active": "1",
 "number": "0"
 },
 {
 "id": "4",
 "name": "Chỗ để xe",
 "position": "4",
 "img": "http://thuenha.site/uploads/utility/car-parking.png",
 "content": "Chỗ để xe",
 "date": "2018-11-17 21:28:56",
 "active": "1",
 "number": "0"
 },
 {
 "id": "5",
 "name": "Bếp nấu ăn",
 "position": "5",
 "img": "http://thuenha.site/uploads/utility/fire.png",
 "content": "Bếp nấu ăn",
 "date": "2018-11-17 21:29:15",
 "active": "1",
 "number": "0"
 },
 {
 "id": "7",
 "name": "Internet",
 "position": "8",
 "img": "http://thuenha.site/uploads/utility/internet.png",
 "content": "Internet",
 "date": "2018-11-17 21:29:46",
 "active": "1",
 "number": "0"
 },
 {
 "id": "9",
 "name": "Phòng Vệ sinh",
 "position": "9",
 "img": "http://thuenha.site/uploads/utility/washroom.png",
 "content": "Phòng Vệ sinh",
 "date": "2018-11-17 21:30:41",
 "active": "1",
 "number": "0"
 }
 ],

 */

class UtilityProductDetail: Mi {
    var id = ""
    var name = ""
    var position = ""
    var img = ""
    var content = ""
    var date = ""
    var active = ""
    var number = ""
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }

    
    class func list(value : [NSDictionary]) -> [UtilityProductDetail]
    {
        var list : [UtilityProductDetail] = []
        for item in value
        {
            let object = UtilityProductDetail.init(dictionary: item)
            list.append(object)
        }
        return list
    }
}
