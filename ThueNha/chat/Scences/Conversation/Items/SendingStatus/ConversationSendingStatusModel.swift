//
//  ConversationSendingStatusModel.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Chatto
import ChattoAdditions

class ConversationSendingStatusModel: ChatItemProtocol {
    
    let uid: String
    static var chatItemType: ChatItemType {
        return "decoration-status"
    }
    
    var type: String { return ConversationSendingStatusModel.chatItemType }
    let status: MessageStatus
    
    init (uid: String, status: MessageStatus) {
        self.uid = uid
        self.status = status
    }
}
