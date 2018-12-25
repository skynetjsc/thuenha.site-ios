//
//  ConversationPhotoMessageHandler.swift
//  ThueNha
//
//  Created by LTD on 12/18/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import ChattoAdditions

class ConversationPhotoMessageHandler: BaseMessageInteractionHandlerProtocol {
    
    private let baseHandler: ConversationBaseMessageHandler
    init (baseHandler: ConversationBaseMessageHandler) {
        self.baseHandler = baseHandler
    }
    
    func userDidTapOnFailIcon(viewModel: ConversationTextMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
    func userDidTapOnAvatar(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidTapOnBubble(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidSelectMessage(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidSelectMessage(viewModel: viewModel)
    }
    
    func userDidDeselectMessage(viewModel: ConversationTextMessageViewModel) {
        self.baseHandler.userDidDeselectMessage(viewModel: viewModel)
    }
    
}
