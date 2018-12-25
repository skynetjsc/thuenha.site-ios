//
//  ConversationMessageFactory.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ConversationMessageFactory {

    class func makeTNChatMessageModel(_ uid: String, message: ChatMessageModel, isIncoming: Bool) -> ConversationTextMessageModel {
        let messageModel = self.makeMessageModel(uid, isIncoming: isIncoming, type: TextMessageModel<MessageModel>.chatItemType)
        if let type = message.type {
            if type == 1 {
                if (UserManager.user.type() == 1) {
                    messageModel.senderId = "1"
                    messageModel.isIncoming = false
                    messageModel.status = .success
                } else if (UserManager.user.type() == 2) {
                    messageModel.senderId = "2"
                    messageModel.isIncoming = true
                    messageModel.status = .success
                }
            } else if type == 2 {
                if (UserManager.user.type() == 1) {
                    messageModel.senderId = "2"
                    messageModel.isIncoming = true
                    messageModel.status = .success
                } else if (UserManager.user.type() == 2) {
                    messageModel.senderId = "1"
                    messageModel.isIncoming = false
                    messageModel.status = .success
                }
            }
        }
        let chatMessageModel = ConversationTextMessageModel(messageModel: messageModel, text: message.content ?? "")
        chatMessageModel.tnChatMessageModel = message
        return chatMessageModel
    }
    
    class func makeTextMessage(_ uid: String, text: String, isIncoming: Bool) -> ConversationTextMessageModel {
        let messageModel = self.makeMessageModel(uid, isIncoming: isIncoming, type: TextMessageModel<MessageModel>.chatItemType)
        let textMessageModel = ConversationTextMessageModel(messageModel: messageModel, text: text)
        return textMessageModel
    }
    
    class func makePhotoMessage(_ uid: String, postModel: PostModel, isIncoming: Bool) -> ConversationPhotoMessageModel {
        let messageModel = self.makeMessageModel(uid, isIncoming: isIncoming, type: PhotoMessageModel<MessageModel>.chatItemType)
        messageModel.status = .success
        let photoMessageModel = ConversationPhotoMessageModel(messageModel: messageModel, imageSize: CGSize(width: 260, height: 158), image: UIImage())
        photoMessageModel.postModel = postModel
        return photoMessageModel
    }
    
    class func makeRandomTextMessage(_ uid: String, isIncoming: Bool) -> ConversationTextMessageModel {
        let text = Lorem.sentences(2)
        return self.makeTextMessage(uid, text: text, isIncoming: isIncoming)
    }
    
    private class func makeMessageModel(_ uid: String, isIncoming: Bool, type: String) -> MessageModel {
        let senderId = isIncoming ? "1" : "2"
        let messageStatus = isIncoming || arc4random_uniform(100) % 3 == 0 ? MessageStatus.success : .failed
        return MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: Date(), status: messageStatus)
    }
    
}

extension TextMessageModel {
    
    static var chatItemType: ChatItemType {
        return "text"
    }
}

extension PhotoMessageModel {
    static var chatItemType: ChatItemType {
        return "photo"
    }
}
