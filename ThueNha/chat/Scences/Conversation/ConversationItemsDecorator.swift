//
//  ConversationItemsDecorator.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Chatto
import ChattoAdditions

final class ConversationItemsDecorator: ChatItemsDecoratorProtocol {
    
    private struct Constants {
        static let shortSeparation: CGFloat = 3
        static let normalSeparation: CGFloat = 10
        static let timeIntervalThresholdToIncreaseSeparation: TimeInterval = 120
    }
    
    private let messagesSelector: ConversationMessagesSelectorProtocol
    
    init(messagesSelector: ConversationMessagesSelectorProtocol) {
        self.messagesSelector = messagesSelector
    }
    
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        var decoratedChatItems = [DecoratedChatItem]()
        let calendar = Calendar.current
        
        for (index, chatItem) in chatItems.enumerated() {
            let next: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let prev: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil
            
            let bottomMargin = self.separationAfterItem(chatItem, next: next)
            let showsTail = false
            var showAvatar = false
            var additionalItems =  [DecoratedChatItem]()
            var addTimeSeparator = false
            var isSelected = false
            var isShowingSelectionIndicator = false
            
            if let currentMessage = chatItem as? MessageModelProtocol {
                if let nextMessage = next as? MessageModelProtocol {
                    showAvatar = currentMessage.senderId != nextMessage.senderId
                } else {
                    showAvatar = true
                }
                
                if let previousMessage = prev as? MessageModelProtocol {
                    addTimeSeparator = !calendar.isDate(currentMessage.date, inSameDayAs: previousMessage.date)
                } else {
                    addTimeSeparator = true
                }
                
                if self.showsStatusForMessage(currentMessage) {
                    let uidString = "\(currentMessage.uid)-conversation-decoration-status"
                    let status = currentMessage.status
                    let sendingStatusModel = ConversationSendingStatusModel(uid: uidString, status: status)
                    let sendingStatus = DecoratedChatItem(chatItem: sendingStatusModel, decorationAttributes: nil)
                    additionalItems.append(sendingStatus)
                }
                
                if addTimeSeparator {
                    let uidString = "\(currentMessage.uid)-conversation-time-separator"
                    let dateString = currentMessage.date.toWeekDayAndDateString()
                    let timeSeparator = ConversationTimeSeparatorModel(uid: uidString, date: dateString)
                    let dateTimeStamp = DecoratedChatItem(chatItem: timeSeparator, decorationAttributes: nil)
                    decoratedChatItems.append(dateTimeStamp)
                }
                
                isSelected = self.messagesSelector.isMessageSelected(currentMessage)
                isShowingSelectionIndicator = self.messagesSelector.isActive && self.messagesSelector.canSelectMessage(currentMessage)
            }
            
            let messageDecorationAttributes = BaseMessageDecorationAttributes(canShowFailedIcon: true,
                                                                              isShowingTail: showsTail,
                                                                              isShowingAvatar: showAvatar,
                                                                              isShowingSelectionIndicator: isShowingSelectionIndicator,
                                                                              isSelected: isSelected)
            let chatItemDecorationAtt = ChatItemDecorationAttributes(bottomMargin: bottomMargin, messageDecorationAttributes: messageDecorationAttributes)
            let decoratedChatItem = DecoratedChatItem(chatItem: chatItem, decorationAttributes: chatItemDecorationAtt)
            decoratedChatItems.append(decoratedChatItem)
            decoratedChatItems.append(contentsOf: additionalItems)
        }
        
        return decoratedChatItems
    }
    
    private func separationAfterItem(_ current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
        guard let nexItem = next else { return 0 }
        guard let currentMessage = current as? MessageModelProtocol else { return Constants.normalSeparation }
        guard let nextMessage = nexItem as? MessageModelProtocol else { return Constants.normalSeparation }
        
        if self.showsStatusForMessage(currentMessage) {
            return 0
        } else if currentMessage.senderId != nextMessage.senderId {
            return Constants.normalSeparation
        } else if nextMessage.date.timeIntervalSince(currentMessage.date) > Constants.timeIntervalThresholdToIncreaseSeparation {
            return Constants.normalSeparation
        } else {
            return Constants.shortSeparation
        }
    }
    
    private func showsStatusForMessage(_ message: MessageModelProtocol) -> Bool {
        return message.status == .failed || message.status == .sending
    }
}
