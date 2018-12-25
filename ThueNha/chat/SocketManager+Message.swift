//
//  SocketManager+Message.swift
//  ThueNha
//
//  Created by Hồng Vũ on 12/14/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

public enum SocketMessage {
    
    case eventViewPost(postMessage: Encodable)
    case eventNotification(notificationMessage: Encodable)
    case eventChat(chatMessage: Encodable)
    
    public var value: Encodable {
        switch self {
        case .eventViewPost(let post):
            return post
        case .eventNotification(let notificaion):
            return notificaion
        case .eventChat(let chatMessage):
            return chatMessage
        }
    }
}

extension SocketManager {
    
}
