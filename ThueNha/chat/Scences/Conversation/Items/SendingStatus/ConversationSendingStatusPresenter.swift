//
//  ConversationSendingStatusPresenter.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

public class ConversationSendingStatusPresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is ConversationSendingStatusModel ? true : false
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return ConversationSendingStatusPresenter(
            statusModel: chatItem as! ConversationSendingStatusModel
        )
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return ConversationSendingStatusPresenter.self
    }
}

class ConversationSendingStatusPresenter: ChatItemPresenterProtocol {
    
    let statusModel: ConversationSendingStatusModel
    init (statusModel: ConversationSendingStatusModel) {
        self.statusModel = statusModel
    }
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "ConversationSendingStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ConversationSendingStatusCollectionViewCell")
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationSendingStatusCollectionViewCell", for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let statusCell = cell as? ConversationSendingStatusCollectionViewCell else {
            assert(false, "expecting status cell")
            return
        }
        
        let attrs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0),
            NSAttributedString.Key.foregroundColor: self.statusModel.status == .failed ? UIColor.red : UIColor.black
        ]
        statusCell.text = NSAttributedString(
            string: self.statusText(),
            attributes: attrs)
    }
    
    func statusText() -> String {
        switch self.statusModel.status {
        case .failed:
            return NSLocalizedString("Sending failed", comment: "")
        case .sending:
            return NSLocalizedString("Sending...", comment: "")
        default:
            return ""
        }
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 19
    }
}

