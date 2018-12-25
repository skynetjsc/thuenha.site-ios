//
//  ListConversationConfigurator.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

final class ListConversationConfigurator {

    // MARK: - Singleton

    static let sharedInstance: ListConversationConfigurator = ListConversationConfigurator()
    
    init() {
        
    }
    
    deinit {
        print("ListConversationConfigurator \(#function)")
    }

    // MARK: - Configuration

    func configure(viewController: ListConversationViewController) {

        let router = ListConversationRouter(viewController: viewController)
        let presenter = ListConversationPresenter(output: viewController)
        let interactor = ListConversationInteractor(output: presenter)
        
        router.dataStore = interactor
        viewController.output = interactor
        viewController.router = router
    }
}
