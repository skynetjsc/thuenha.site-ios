//
//  ConversationConfigurator.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

final class ConversationConfigurator {

    // MARK: - Singleton

    static let sharedInstance: ConversationConfigurator = ConversationConfigurator()
    
    init() {
        
    }
    
    deinit {
        print("ConversationConfigurator \(#function)")
    }

    // MARK: - Configuration

    func configure(viewController: ConversationViewController) {

        let router = ConversationRouter(viewController: viewController)
        let presenter = ConversationPresenter(output: viewController)
        let interactor = ConversationInteractor(output: presenter)
        
        router.dataStore = interactor
        viewController.output = interactor
        viewController.router = router
        viewController.dataSource = ConversationDataSource(count: 0, pageSize: 50)
    }
}
