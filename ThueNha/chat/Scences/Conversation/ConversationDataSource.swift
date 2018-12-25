//
//  ConversationDataSource.swift
//  ThueNha
//
//  Created by LTD on 12/7/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Chatto

class ConversationDataSource : ChatDataSourceProtocol {
    
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500
    
    var slidingWindow: ConversationSlidingDataSource<ChatItemProtocol>!
    
    init(count: Int, pageSize: Int) {
        self.slidingWindow = ConversationSlidingDataSource(count: count, pageSize: pageSize, itemGenerator: nil)
    }
    
    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = ConversationSlidingDataSource(items: messages, pageSize: pageSize)
    }
    
    lazy var messageSender: ConversationMessageSender = {
        let sender = ConversationMessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else {
                return
            }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }
    
    var chatItems: [ChatItemProtocol] {
        return self.slidingWindow.itemsInWindow
    }
    
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }
    
    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }
    
    func addTNChatMessage(message: ChatMessageModel, isIncoming: Bool) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = ConversationMessageFactory.makeTNChatMessageModel(uid, message: message, isIncoming: isIncoming)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func addTextMessage(_ text: String) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = ConversationMessageFactory.makeTextMessage(uid, text: text, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func addRandomIncomingTextMessage() {
        let message = ConversationMessageFactory.makeRandomTextMessage("\(self.nextMessageId)", isIncoming: true)
        self.nextMessageId += 1
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust)
    }
    
}
