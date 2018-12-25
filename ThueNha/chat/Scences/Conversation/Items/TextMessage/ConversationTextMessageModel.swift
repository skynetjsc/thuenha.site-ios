//
//  ConversationTextMessageModel.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import ChattoAdditions

public class ConversationTextMessageModel: TextMessageModel<MessageModel>, ConversationMessageModelProtocol {
    
    public var tnChatMessageModel: ChatMessageModel?
    
    public override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
    
    public var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}
