//
//  ListConversationResponseModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol ListConversationResponseModelProtocol: BaseResponseModelProtocol  where ResponseData == [ConversationModel]  {

}

struct ListConversationResponseModel: Codable, ListConversationResponseModelProtocol {
    var data: [ConversationModel]
    var errorId: Int
    var message: String
}

