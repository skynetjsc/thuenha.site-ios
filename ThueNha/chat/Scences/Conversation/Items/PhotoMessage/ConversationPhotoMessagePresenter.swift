//
//  ConversationPhotoMessagePresenter.swift
//  ThueNha
//
//  Created by Hồng Vũ on 12/16/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

public class ConversationPhotoMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    weak var viewController: ConversationViewController?
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is ConversationPhotoMessageModel ? true : false
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        let presenter = ConversationPhotoMessagePresenter(photoMessageModel: chatItem as! ConversationPhotoMessageModel)
        presenter.delegate = viewController
        return presenter
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return ConversationPhotoMessagePresenter.self
    }
}

protocol ConversationPhotoMessageDelegate: class {
    func conversationPhotoMessage(presenter: ConversationPhotoMessagePresenter)
}

class ConversationPhotoMessagePresenter: ChatItemPresenterProtocol {
    
    weak var delegate: ConversationPhotoMessageDelegate?
    
    let photoMessageModel: ConversationPhotoMessageModel
    init (photoMessageModel: ConversationPhotoMessageModel) {
        self.photoMessageModel = photoMessageModel
    }
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "ConversationPhotoMessageCell", bundle: nil), forCellWithReuseIdentifier: "ConversationPhotoMessageCell")
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationPhotoMessageCell", for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let photoMessageCell = cell as? ConversationPhotoMessageCell else {
            assert(false, "expecting status cell")
            return
        }
        
        photoMessageCell.titleLabel?.text = self.photoMessageModel.postModel.title
        photoMessageCell.addressLabel?.text = self.photoMessageModel.postModel.address
        photoMessageCell.priceLabel?.text = String(format: "%@đ/tháng", Int(self.photoMessageModel.postModel.price)!.withCommas())
        photoMessageCell.titleLabel?.textColor = UIColor.thueNhaBlack
        photoMessageCell.addressLabel?.textColor = UIColor.thueNhaBlack
        photoMessageCell.priceLabel?.textColor = UIColor.thueNhaBlack
        photoMessageCell.titleLabel?.font = UIFont.thueNhaOpenSansRegular(size: 14)
        photoMessageCell.addressLabel?.font = UIFont.thueNhaOpenSansRegular(size: 14)
        photoMessageCell.priceLabel?.font = UIFont.thueNhaOpenSansRegular(size: 14)
        photoMessageCell.imgView?.kf.setImage(with: URL(string: self.photoMessageModel.postModel.avatar))
        photoMessageCell.imgView?.layer.cornerRadius = 10.0
        photoMessageCell.imgView?.clipsToBounds = true
        photoMessageCell.borderView?.layer.cornerRadius = 10.0
        photoMessageCell.borderView?.layer.borderWidth = 1.0
        photoMessageCell.borderView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchupInsideImage))
        tapGesture.numberOfTapsRequired = 1
        photoMessageCell.imgView?.addGestureRecognizer(tapGesture)
        photoMessageCell.imgView?.isUserInteractionEnabled = true
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 220
    }
    
    @objc private func touchupInsideImage() {
        delegate?.conversationPhotoMessage(presenter: self)
    }
}
