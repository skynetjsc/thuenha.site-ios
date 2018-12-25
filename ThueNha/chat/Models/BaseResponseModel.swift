//
//  BaseResponseModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol BaseResponseModelProtocol {
    associatedtype ResponseData
    
    var data: ResponseData { get set }
    var errorId: Int { get set }
    var message: String { get set }
}
