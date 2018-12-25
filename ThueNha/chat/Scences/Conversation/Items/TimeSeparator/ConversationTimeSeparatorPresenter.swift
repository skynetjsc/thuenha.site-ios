//
//  ConversationTimeSeparatorPresenter.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Chatto

public class ConversationTimeSeparatorPresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is ConversationTimeSeparatorModel
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return ConversationTimeSeparatorPresenter(timeSeparatorModel: chatItem as! ConversationTimeSeparatorModel)
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return ConversationTimeSeparatorPresenter.self
    }
}

class ConversationTimeSeparatorPresenter: ChatItemPresenterProtocol {
    
    let timeSeparatorModel: ConversationTimeSeparatorModel
    init (timeSeparatorModel: ConversationTimeSeparatorModel) {
        self.timeSeparatorModel = timeSeparatorModel
    }
    
    private static let cellReuseIdentifier = ConversationTimeSeparatorCollectionViewCell.self.description()
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(ConversationTimeSeparatorCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ConversationTimeSeparatorPresenter.cellReuseIdentifier, for: indexPath)
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let timeSeparatorCell = cell as? ConversationTimeSeparatorCollectionViewCell else {
            assert(false, "expecting status cell")
            return
        }
        
        timeSeparatorCell.text = self.timeSeparatorModel.date
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 24
    }
}
