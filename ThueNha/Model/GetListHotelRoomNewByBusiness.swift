//
//  GetListHotelRoomNewByBusiness.swift
//  ReBook
//
//  Created by Lâm Phạm on 10/28/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit

class GetListHotelRoomNewByBusiness: MasterModel {
    var HotelRoomID = 0
    var HotelRoomName = ""
    var HotelRoomFloorID = 0
    var HotelRoomFloorName = ""
    var HotelRoomClassID = 0
    var HotelRoomClassName = ""
    var NumberForBeds = 0
    var NumberForGuests = 0
    var OrderIndex = 0
    var IsActive = false
    var IsDeleted = false
    var IsSystem = false
    var CreatedStoredID = 0
    var CreatedDate = ""
    var UpdatedDate = ""
    var DeletedDate = ""
    var BusinessName = ""
    var NumberGuestBook: Int = 0
    
    var NumberGuestOfRoom: Int = 0
    var StatusRoom: Int = 0
    
    var isSelected = false
    var finishGetNumberGuest = false
    var finishGetStatus = false
    var indexPath: IndexPath!
    
    class func list(value : [NSDictionary]) -> [GetListHotelRoomNewByBusiness]
    {
        var list : [GetListHotelRoomNewByBusiness] = []
        for item in value
        {
            let object = GetListHotelRoomNewByBusiness.init(dictionary: item)
            list.append(object)
        }
        return list
    }
}

class GetListHotelRoomNewByBusiness_Request: MasterModel {
    var businessID = ""
}

extension Services {
    /*
    func getListHotelRoomNewByBusiness(param: GetListHotelRoomNewByBusiness_Request, success: @escaping(([GetListHotelRoomNewByBusiness]) -> Void), failure: @escaping((APIResponse) -> Void)) {
        services.request(api: .getListHotelRoomNewByBusiness, method: .get, param: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success(GetListHotelRoomNewByBusiness.list(value: response.Result as! [Dictionary<String,Any>] as [NSDictionary]))
        }) { (error) in
            failure(error)
        }
    }*/
    /*
     func getListRooms() {
     weak var weakSelf = self
     let param = GetListHotelRoomNewByBusiness_Request()
     param.businessID = userInstance.selectedBusinessModel.BusinessID
     weakSelf?.view.showHud()
     services.getListHotelRoomNewByBusiness(param: param, success: { (listRooms) in
     if listRooms.count == 0 {
     self.view.hideHud()
     
     self.isNoData = true
     self.tableView.reloadData()
     }else{
     weakSelf?.setListRoom(room: listRooms)
     }
     }) { (error) in
     self.view.hideHud()
     self.refreshControlCurr.endRefreshing()
     
     if error.isDisconnected {
     weakSelf?.view.dialog(title: template.ERROR_TEXT, desc: error.Message, type: .warning, acceptBlock: { () in
     
     }) { () in
     
     }
     self.isNoData = true
     self.isInternet = true
     }else{
     self.isNoData = true
     self.isInternet = false
     }
     self.tableView.reloadData()
     }
     }
     */
}



