//
//  ConversationInteractor.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwifterSwift

protocol ConversationInteractorInput: ConversationViewControllerOutput {

}

protocol ConversationInteractorOutput {
    
    func responseMessageHistory(response: Conversation.Response, _ error: Error?)
    func responseSendTnChat(response: Conversation.Response)
    func responseReceiveMessage(reponse: Conversation.Response)
}

protocol ConversationDataStore {
    var conversation: ConversationModel? { get set }
}

final class ConversationInteractor: ConversationDataStore {

    let output: ConversationInteractorOutput
    let worker: ConversationWorker
    
    var conversation: ConversationModel?

    // MARK: - Initializers

    init(output: ConversationInteractorOutput, worker: ConversationWorker = ConversationWorker()) {
        self.output = output
        self.worker = worker
        
        subscribe()
    }
    
    func subscribe() {
        let channel = SocketManager.sharedInstance.channel
        channel.subscribe(self, block: { [weak self] message in
            switch message {
            case .eventChat(let chatMessage as ChatMessageModel):
                self?.socketManager(onMessageReceived: chatMessage)
            default:
                break
            }
        })
    }
    
    deinit {
        print("ConversationInteractor \(#function)")
    }
}

// MARK: - ConversationInteractorInput

extension ConversationInteractor: ConversationViewControllerOutput {
    
    // MARK: - Business logic
    
    func requestMessageHistory(request: Conversation.Request) {
        guard let idUser = conversation?.user?.id,
            let idHost = conversation?.host?.id,
            let idPost = conversation?.idPost else {
                // TODO:
                return
        }
        worker.requestMessageHistory(idUser: idUser, idHost: idHost, idPost: idPost) { [weak self] (response, error) in
            var responseModel = Conversation.Response()
            if (UserManager.user.type() == 1) {
                responseModel.title = response?.data.nameHost
            } else if (UserManager.user.type() == 2) {
                responseModel.title = response?.data.nameUser
            }
            responseModel.messagesHistory = response?.data.content
            responseModel.postDetails = response?.data.post
            self?.output.responseMessageHistory(response: responseModel, error)
        }
    }
    
    func requestConnectSocket() {
        SocketManager.sharedInstance.connect()
    }
    
    func requestSendTnChat(request: Conversation.Request) {
        guard let idUser = conversation?.user?.id,
            let idHost = conversation?.host?.id,
            let idPost = conversation?.idPost else {
                // TODO:
                return
        }
        
        var message = ChatMessageModel()
        message.sendFrom = UserManager.user.id()
        message.idUser = idUser
        message.idHost = idHost
        message.idPost = Int(idPost)
        message.type = UserManager.user.type()
        message.content = request.message
        message.time = Date().messageTimeString()
        message.attach = "0"
    
        SocketManager.sharedInstance.sendTNChat(message)
        
        var response = Conversation.Response()
        response.message = message
        output.responseSendTnChat(response: response)
        
        // POST message to saved in server
        let requestPostMessage = Conversation.Request.POSTMessage(userId: idUser,
                                                                  hostId: idHost,
                                                                  postId: idPost,
                                                                  time: message.time ?? Date().messageTimeString(),
                                                                  type: "\(UserManager.user.type())",
            content: message.content ?? "",
            attachId: message.attach ?? "0")
        self.requestPOSTMessage(request: requestPostMessage, completion: { })
    }
    
    func requestPOSTMessage(request: Conversation.Request.POSTMessage,
                            completion: @escaping() -> Void) {
        worker.requestMessage(idUser: request.userId,
                              idHost: request.hostId,
                              idPost: request.postId,
                              type: request.type,
                              content: request.content,
                              time: request.time,
                              attach: request.attachId,
                              completion: {
                                completion()
        })
    }
}

extension ConversationInteractor: SocketManagerOutputProtocol {
    
    func socketManager(onMessageReceived: ChatMessageModel) {
        var response = Conversation.Response()
        response.message = onMessageReceived
        output.responseReceiveMessage(reponse: response)
    }
    
}

extension Date {
    
    func messageTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
