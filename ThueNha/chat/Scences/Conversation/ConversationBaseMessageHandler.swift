//
//  ConversationBaseMessageHandler.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ConversationBaseMessageHandler {
    
    private let messageSender: ConversationMessageSender
    private let messagesSelector: ConversationMessagesSelectorProtocol
    
    init(messageSender: ConversationMessageSender, messagesSelector: ConversationMessagesSelectorProtocol) {
        self.messageSender = messageSender
        self.messagesSelector = messagesSelector
    }
    func userDidTapOnFailIcon(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidTapOnFailIcon")
        self.messageSender.sendMessage(viewModel.messageModel)
    }
    
    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
        print("userDidTapOnAvatar")
    }
    
    func userDidTapOnBubble(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidTapOnBubble")
    }
    
    func userDidBeginLongPressOnBubble(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidBeginLongPressOnBubble")
    }
    
    func userDidEndLongPressOnBubble(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidEndLongPressOnBubble")
    }
    
    func userDidSelectMessage(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidSelectMessage")
        self.messagesSelector.selectMessage(viewModel.messageModel)
    }
    
    func userDidDeselectMessage(viewModel: ConversationMessageViewModelProtocol) {
        print("userDidDeselectMessage")
        self.messagesSelector.deselectMessage(viewModel.messageModel)
    }
}
