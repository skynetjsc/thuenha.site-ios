//
//  MessagesSelectorProtocol.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import ChattoAdditions

public protocol ConversationMessagesSelectorDelegate: class {
    func messagesSelector(_ messagesSelector: ConversationMessagesSelectorProtocol, didSelectMessage: MessageModelProtocol)
    func messagesSelector(_ messagesSelector: ConversationMessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol)
}

public protocol ConversationMessagesSelectorProtocol: class {
    weak var delegate: ConversationMessagesSelectorDelegate? { get set }
    var isActive: Bool { get set }
    func canSelectMessage(_ message: MessageModelProtocol) -> Bool
    func isMessageSelected(_ message: MessageModelProtocol) -> Bool
    func selectMessage(_ message: MessageModelProtocol)
    func deselectMessage(_ message: MessageModelProtocol)
    func selectedMessages() -> [MessageModelProtocol]
}
