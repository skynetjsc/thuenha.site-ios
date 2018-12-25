//
//  ConversationModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol ConversationModelProtocol {
    var lastMessage: String? { get set }
    var time: String? { get set }
    var idPost: String? { get set }
    var timeUpdated: String? { get set }
    var user: UserModel? { get set }
    var host: UserModel? { get set }
}

struct ConversationModel: Codable, ConversationModelProtocol {
    var lastMessage: String?
    var time: String?
    var idPost: String?
    var timeUpdated: String?
    var user: UserModel?
    var host: UserModel?
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case lastMessage = "last_message"
        case time
        case idPost = "id_post"
        case timeUpdated = "time_updated"
        case user
        case host
    }
}
