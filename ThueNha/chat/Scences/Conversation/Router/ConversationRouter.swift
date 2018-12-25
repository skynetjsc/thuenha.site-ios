//
//  ConversationRouter.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ConversationRouterProtocol: ConversationDataPassing {

    var viewController: ConversationViewController? { get }

    func navigateToPostDetails(_ post: PostModel)
    
    func popViewController(_ animated: Bool)
}

protocol ConversationDataPassing {
    var dataStore: ConversationDataStore? { get }
}

final class ConversationRouter {

    weak var viewController: ConversationViewController?
    
    var dataStore: ConversationDataStore?

    // MARK: - Initializers

    init(viewController: ConversationViewController?) {
        self.viewController = viewController
    }
    
    deinit {
        print("ConversationRouter \(#function)")
    }
}

// MARK: - ConversationRouterProtocol

extension ConversationRouter: ConversationRouterProtocol {

    // MARK: - Navigation

    func navigateToPostDetails(_ post: PostModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productDetailVC = storyboard.instantiateViewController(withIdentifier: "productDetails") as? ProductDetailsViewController {
            productDetailVC.post_id = post.id
            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    func popViewController(_ animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
    
    /* Navigate to somewhere with passing data example
    func navigateToSomewhere() {
        let destinationViewController = DestinationViewController(nibName: "nibName", bundle: "bundle")
        var destinationDS = destinationViewController.router.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func passData(source: ConversationDataStore?, destination: inout DestinationDataStore?) {
        destination.mData = source.mData
    }
    */
}
