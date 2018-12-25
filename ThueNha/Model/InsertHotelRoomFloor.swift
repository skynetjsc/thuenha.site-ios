//
//  InsertHotelRoomFloorModel.swift
//  ReBook
//
//  Created by Vinh on 9/13/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit
/*
 Thêm Tầng
 1. Nhập data hợp lệ
 {
 "HotelRoomFloorID": 0,
 "BusinessID": "000113100022",
 "HotelRoomFloorName": "Tầng 5",
 "Description": "Với 6 phòng có view hướng ra biển",
 "OrderIndex": 6,
 "IsActive": false,
 "IsSystem": false,
 "CreatedStoreID": 0,
 "CreatedUser": "",
 "CreatedDate": "",
 "IsDeleted": false,
 "UpdatedUser": "",
 "UpdatedDate": "",
 "DeletedUser": "",
 "DeletedDate": ""
 }
 2. Không nhập gì
 ---
 1. Kết quả trả về khi nhập đúng data
 {
 "Result": {
 HotelRoomFloorID : 0
 },
 "Status": 0,
 "Error": false,
 "Message": "Thêm thành công"
 }
 2. Kết quả trả về khi không nhập gì và update
 {
 "Result": {  },
 "Status": 0,
 "Error": true,
 "Message": “the request is invalid“
 }


 
*/

class InsertHotelRoomFloor: Mi {
    var HotelRoomFloorID = 0
    
    class func list(value : [NSDictionary]) -> [InsertHotelRoomFloor]
    {
        var list : [InsertHotelRoomFloor] = []
        for item in value
        {
            let object = InsertHotelRoomFloor.init(dictionary: item)
            list.append(object)
        }
        return list
    }

}

class InsertHotelRoomFloor_Request: Mi {
    var HotelRoomFloorID = 0
    var BusinessID = ""
    var HotelRoomFloorName = ""
    var Description = ""
    var OrderIndex = 0
    var IsActive = true
    var IsSystem = false
    var CreatedStoreID = 0
    var IsDeleted = false
}
extension Services{
    

    /*
    func insertHotelRoomFloor(request : InsertHotelRoomFloor_Request, success: @escaping ((InsertHotelRoomFloor)->Void), failure:@escaping ((APIResponse)-> Void)){
        services.request(api: .insertHotelRoomFloor, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let insertFloor = InsertHotelRoomFloor.init(dictionary: response.Result as! NSDictionary)
            success(insertFloor)
            
        }) { (error) in failure(error)
            
        }
    }*/
    /*
    func insertHotelRoomFloor() {
        
        weak var weakSelf = self
        let request = InsertHotelRoomFloor_Request()
        request.BusinessID = userInstance.selectedBusinessModel.BusinessID
        request.Description = viewDescriptionFloor.getValue() as! String
        request.HotelRoomFloorName = viewNameFloor.getValue() as! String
        request.IsActive = isStatus
        services.insertHotelRoomFloor(request: request, success: { (response) in
            weakSelf?.view.dialog(title:  template.SUCCESS_TEXT, desc: "Thêm thành công", type: .info, acceptBlock: { () in
                app.pop()
            }) { () in
                
            }
            
            
            
        }) { (error) in
            self.view.isUserInteractionEnabled = true
            if error.isDisconnected {
                weakSelf?.view.dialog(title: template.ERROR_TEXT, desc: error.Message, type: .warning, acceptBlock: { () in
                    
                }) { () in
                    
                }
            }else{
                weakSelf?.view.dialog(title: template.ERROR_TEXT, desc: error.Message, type: .warning, acceptBlock: { () in
                    
                }) { () in
                    
                }
            }
        }
    }
 */
    
}

