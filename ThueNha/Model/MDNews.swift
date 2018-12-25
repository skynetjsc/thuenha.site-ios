//
//  MDNews.swift
//  ThueNha
//
//  Created by Hoang Son on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class MDNews: NSObject {
    var address : String?
    var city_id : String?
    var id_service : String?
    var type : String?
    var id : String?
    var date : String?
    var host_id : String?
    var content : String?
    var area : String?
    var note : String?
    var number_bed : String?
    var avatar : String?
    var active : String?
    var arrayUti : Array<Any>?
    var price : String?
    var id_utility : String?
    var number_wc : String?
    var district_id : String?
    var title : String?
    var number_seen : Int?
    

    override init() {
        super.init()
    }
    init(address : String, city_id : String, id_service : String, type : String, id : String, date : String, host_id : String, content : String, area : String, note : String, number_bed : String, avatar : String, active : String, arrayUti : Array<Any>, price : String, id_utility : String, number_wc : String, district_id : String, title : String, number_seen : Int) {
        self.address = address
        self.city_id = city_id
        self.id_service = id_service
        self.type = type
        self.id = id
        self.date = date
        self.host_id = host_id
        self.content = content
        self.area = area
        self.note = note
        self.number_bed = number_bed
        self.avatar = avatar
        self.active = active
        self.arrayUti = arrayUti
        self.price = price
        self.id_utility = id_utility
        self.number_wc = number_wc
        self.district_id = district_id
        self.title = title
        self.number_seen = number_seen
    }

}
