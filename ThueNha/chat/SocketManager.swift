//
//  SocketManager.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import SocketIO

enum SocketEventType: Int {
    case viewPost
    case tnNotification
    case tnChat
    
    var description: String {
        switch self {
        case .viewPost:
            return "send_view_post"
        case .tnNotification:
            return "send_tn_notification"
        case .tnChat:
            return "send_tn_chat"
        }
    }
}

enum SocketSendType: Int {
    case sendViewPost
    case sendTnNotification
    case sendTnChat
    
    var description: String {
        switch self {
        case .sendViewPost:
            return "view_post"
        case .sendTnNotification:
            return "tn_notification"
        case .sendTnChat:
            return "tn_chat"
        }
    }
}

enum SocketStatusType: Int {
    case connected
    case disconnected
    
    var description: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        }
    }
}

protocol SocketManagerOutputProtocol {

    func socketManager(onStatus: SocketStatusType)
    func socketManager(onMessageReceived: ChatMessageModel)
}

extension SocketManagerOutputProtocol {
    
    func socketManager(onStatus: SocketStatusType) { }
    func socketManager(onMessageReceived: ChatMessageModel) { }
}

protocol SocketManagerInputProtocol {
    
    func sendViewPost()
    func sendTNNotification()
    func sendTNChat(_ tnChatModel: ChatMessageModel)
}

final class SocketManager {
    
    static let sharedInstance = SocketManager()
    
    var output: SocketManagerOutputProtocol?
    let channel = Channel<SocketMessage>()
    private var manager: SocketIO.SocketManager?
    private var isConnected: Bool = false
    private var socket: SocketIOClient?
    
    init() {
        
    }
    
    deinit {
        
    }
    
    func IsConnected() -> Bool {
        return isConnected
    }
    
    func getSocket() -> SocketIOClient {
        return socket!
    }
    
    func getManager() -> SocketIO.SocketManager {
        return manager!
    }
    
    func connect() {
        
        if (IsConnected()) {
            return
        }
        
        manager = SocketIO.SocketManager(socketURL: URL(string: "http://103.237.147.86:3001")!)
        manager?.config = [.log(true), .forcePolling(false), .selfSigned(true), .forceWebsockets(true)]
        
        self.socket = manager?.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
            self.output?.socketManager(onStatus: SocketStatusType.connected)
        }
        
        socket?.on(SocketEventType.viewPost.description) { data, ack in
            print(SocketEventType.viewPost.description)
            print(data)
        }
        
        socket?.on(SocketEventType.tnNotification.description) { data, ack in
            print(SocketEventType.tnNotification.description)
            print(data)
        }
        
        socket?.on(SocketEventType.tnChat.description) { data, ack in
            print(SocketEventType.tnChat.description)
            print(data)
            
            if let message = data.first as? [String: Any] {
                if let messageModel = try? JSONDecoder().decode(ChatMessageModel.self, withJSONObject: message) {
                    self.channel.broadcast(SocketMessage.eventChat(chatMessage: messageModel))
                }
            }
        }
        
        socket?.on("authenticate") { data, ack in
            print("Event")
            print(data)
        }
        
        socket?.on("error") { data, ack in
            print("Error")
            print(data)
            self.isConnected = false
            self.output?.socketManager(onStatus: SocketStatusType.disconnected)
        }
        
        socket?.on("success") { data, ack in
            print("Success")
            print(data)
        }
        
        socket?.connect()
        
        isConnected = true
    }
    
    private func sendData(type: SocketSendType, params: [String: Any]?) {
        if let mParams = params {
            socket?.emit(type.description, mParams)
        } else {
            // TODO:
        }
    }
    
}

extension SocketManager: SocketManagerInputProtocol {
    
    
    public func sendViewPost() {
        
    }
    
    public func sendTNNotification() {
        
    }
    
    public func sendTNChat(_ tnChatModel: ChatMessageModel) {
        if let data = try? JSONEncoder().encodeJSONObject(tnChatModel) as? [String: Any] {
            sendData(type: SocketSendType.sendTnChat, params: data)
        } else {
            // TODO:
        }
    }
    
}
