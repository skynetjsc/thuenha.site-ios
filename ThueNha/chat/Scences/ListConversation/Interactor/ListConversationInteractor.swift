//
//  ListConversationInteractor.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ListConversationInteractorInput: ListConversationViewControllerOutput {

}

protocol ListConversationInteractorOutput {

    func presentListConversation(response: ListConversation.Response)
    func presentDeleteConversation()
    func presentConfirmRent()
}

protocol ListConversationDataStore {
    var listConversation: [ConversationModel]? { get set }
}

final class ListConversationInteractor: ListConversationDataStore {

    let output: ListConversationInteractorOutput
    let worker: ListConversationWorker
    
    var listConversation: [ConversationModel]?

    // MARK: - Initializers

    init(output: ListConversationInteractorOutput, worker: ListConversationWorker = ListConversationWorker()) {
        self.output = output
        self.worker = worker
    }
    
    deinit {
        print("ListConversationInteractor \(#function)")
    }
}

// MARK: - ListConversationInteractorInput

extension ListConversationInteractor: ListConversationViewControllerOutput {
    
    // MARK: - Business logic

    func requestListConversation(request: ListConversation.Request) {
        worker.reqeustListConversation(idUser: request.idUser, type: request.type) { [weak self] (listConversation, error) in
            self?.listConversation = listConversation?.data
            var response = ListConversation.Response()
            response.listConversation = listConversation
            response.error = error
            self?.output.presentListConversation(response: response)
        }
    }
    
    func requestDeleteConversation(request: ListConversation.Request.DeleteConversation) {
        worker.requestDeleteConversation(idUser: request.idUser,
                                         idHost: request.idHost,
                                         idPost: request.idPost,
                                         completion: { [weak self] in
            self?.output.presentDeleteConversation()
        })
    }
    
    func requestConfirmRent(request: ListConversation.Request.ConfirnRent) {
        worker.requestConfirmRent(idUser: request.idUser,
                                  idHost: request.idHost,
                                  idPost: request.idPost,
                                  completion: { [weak self] in
            self?.output.presentConfirmRent()
        })
    }
}
