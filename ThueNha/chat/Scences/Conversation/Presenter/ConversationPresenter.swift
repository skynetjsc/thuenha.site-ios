//
//  ConversationPresenter.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ConversationPresenterInput: ConversationInteractorOutput {

}

protocol ConversationPresenterOutput: class {
    
    func displayMessageHistory(viewModel: Conversation.ViewModel)
    func displayMessageSent(viewModel: Conversation.ViewModel)
    func displayMessageReceived(viewModel: Conversation.ViewModel)
}

final class ConversationPresenter {

    private(set) weak var output: ConversationPresenterOutput!

    // MARK: - Initializers

    init(output: ConversationPresenterOutput) {
        self.output = output
    }
    
    deinit {
        print("ConversationPresenter \(#function)")
    }
}

// MARK: - ConversationPresenterInput

extension ConversationPresenter: ConversationPresenterInput {

    // MARK: - Presentation logic
    
    func responseMessageHistory(response: Conversation.Response, _ error: Error?) {
        var viewModel = Conversation.ViewModel()
        viewModel.title = response.title
        viewModel.messagesHistory = response.messagesHistory
        viewModel.postDetails = response.postDetails
        output.displayMessageHistory(viewModel: viewModel)
    }
    
    func responseSendTnChat(response: Conversation.Response) {
        var viewModel = Conversation.ViewModel()
        viewModel.message = response.message
        output.displayMessageSent(viewModel: viewModel)
    }
    
    func responseReceiveMessage(reponse: Conversation.Response) {
        var viewModel = Conversation.ViewModel()
        viewModel.message = reponse.message
        output.displayMessageReceived(viewModel: viewModel)
    }
}
