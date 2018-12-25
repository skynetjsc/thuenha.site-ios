//
//  ListConversationPresenter.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ListConversationPresenterInput: ListConversationInteractorOutput {

}

protocol ListConversationPresenterOutput: class {

    func displayListConversation(viewModel: ListConversation.ViewModel)
    func displayDeleteConversation()
    func displayConfirmRent()
}

final class ListConversationPresenter {

    private(set) weak var output: ListConversationPresenterOutput!

    // MARK: - Initializers

    init(output: ListConversationPresenterOutput) {
        self.output = output
    }
    
    deinit {
        print("ListConversationPresenter \(#function)")
    }
}

// MARK: - ListConversationPresenterInput

extension ListConversationPresenter: ListConversationPresenterInput {
    
    // MARK: - Presentation logic

    func presentListConversation(response: ListConversation.Response) {
        var viewModel = ListConversation.ViewModel()
        
        var displayedTable = ListConversation.ViewModel.DisplayedTable()
        var displayedSection = ListConversation.ViewModel.DisplayedSection()
        for item in response.listConversation?.data ?? [] {
            var displayedCell = ListConversation.ViewModel.DisplayedCell()
            displayedCell.conversation = item
            displayedSection.cells.append(displayedCell)
        }
        displayedTable.sections.append(displayedSection)
        
        viewModel.displayedTable = displayedTable
        output.displayListConversation(viewModel: viewModel)
    }
    
    func presentDeleteConversation() {
        output.displayDeleteConversation()
    }
    
    func presentConfirmRent() {
        output.displayConfirmRent()
    }
}
