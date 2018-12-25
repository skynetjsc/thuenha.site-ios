//
//  ConversationViewModel.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwifterSwift

struct Conversation {
    
    struct Request {
        var message: String?
        
        struct POSTMessage {
            var userId: String
            var hostId: String
            var postId: String
            var time: String = Date().messageTimeString()
            var type: String = "1"
            var content: String = ""
            var attachId: String
        }
    }
    
    struct Response {
        var title: String? = ""
        
        var socketStatus: SocketStatusType?
        
        var message: ChatMessageModel?
        
        var postDetails: PostModel?
        var messagesHistory: [ChatMessageModel]?
    }
    
    struct ViewModel {
        
        /// 
        var title: String? = ""
        
        ///
        var isConnected: Bool?
        
        ///
        var message: ChatMessageModel?
        
        ///
        var postDetails: PostModel?
        var messagesHistory: [ChatMessageModel]?
    }

}
