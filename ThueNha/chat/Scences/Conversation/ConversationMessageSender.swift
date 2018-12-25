//
//  ConversationMessageSender.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Chatto
import ChattoAdditions

public protocol ConversationMessageModelProtocol: MessageModelProtocol {
    var status: MessageStatus { get set }
}

public class ConversationMessageSender {
    
    public var onMessageChanged: ((_ message: ConversationMessageModelProtocol) -> Void)?
    
    public func sendMessage(_ message: ConversationMessageModelProtocol) {
        updateMessageStatus(message)
    }
    
    private func updateMessageStatus(_ message: ConversationMessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.updateMessageStatus(message)
        case .sending:
            break
        }
    }
    
    private func updateMessage(_ message: ConversationMessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }
    
    private func notifyMessageChanged(_ message: ConversationMessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}
