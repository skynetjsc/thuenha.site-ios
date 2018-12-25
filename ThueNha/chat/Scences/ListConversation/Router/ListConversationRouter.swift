//
//  ListConversationRouter.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

protocol ListConversationRouterProtocol {

    var viewController: ListConversationViewController? { get }

    func navigateToConversation()
    
    #warning("Khai báo method ở đây")
    func chuyen_den_man_cho_thue(post_id:String)
}

protocol ListConversationDataPassing {
    var dataStore: ListConversationDataStore? { get }
}

final class ListConversationRouter: ListConversationDataPassing {

    weak var viewController: ListConversationViewController?
    
    var dataStore: ListConversationDataStore?

    // MARK: - Initializers

    init(viewController: ListConversationViewController?) {
        self.viewController = viewController
    }
    
    deinit {
        print("ListConversationRouter \(#function)")
    }
}

// MARK: - ListConversationRouterProtocol

extension ListConversationRouter: ListConversationRouterProtocol {

    // MARK: - Navigation
    
    func chuyen_den_man_cho_thue(post_id:String) {
        #warning("Chỗ này push/present đến màn nào đó")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "ListViewerViewController") as! ListViewerViewController
        listVC.mPostId = post_id
        listVC.mControllerType = 2
        viewController?.navigationController?.pushViewController(listVC, animated: true)
    }

    func navigateToConversation() {
        let conversationVC = ConversationViewController(nibName: ConversationViewController.nibName, bundle: nil)
        var destinationDS = conversationVC.router.dataStore
        passData(source: dataStore, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func passData(source: ListConversationDataStore?, destination: inout ConversationDataStore?) {
        if let selectedRow = viewController?.tableView?.indexPathForSelectedRow {
            if let listConversation = source?.listConversation {
                let selectedConversation = listConversation[selectedRow.row]
                destination?.conversation = selectedConversation
            }
        }
    }
}
