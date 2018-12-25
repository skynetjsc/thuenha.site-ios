//
//  ConversationTextMessageViewModelBuiller.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import ChattoAdditions
import Kingfisher

public protocol ConversationMessageViewModelProtocol {
    var messageModel: ConversationMessageModelProtocol { get }
}

public class ConversationTextMessageViewModel: TextMessageViewModel<ConversationTextMessageModel>, ConversationMessageViewModelProtocol {

    var user: UserModel?
    var host: UserModel?
    
    public override init(textMessage: ConversationTextMessageModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }
    
    public var messageModel: ConversationMessageModelProtocol {
        return self.textMessage
    }
    
    override public func willBeShown() {
        // Display avatar
        var avatarURL: URL? = nil
        if (UserManager.user.type() == 1) {
            if messageModel.senderId == "1" {
                if let mAvatar = user?.avatar {
                    avatarURL = URL(string: mAvatar)
                }
            } else if messageModel.senderId == "2" {
                if let mAvatar = host?.avatar {
                    avatarURL = URL(string: mAvatar)
                }
            }
        } else if (UserManager.user.type() == 2) {
            if messageModel.senderId == "1" {
                if let mAvatar = host?.avatar {
                    avatarURL = URL(string: mAvatar)
                }
            } else if messageModel.senderId == "2" {
                if let mAvatar = user?.avatar {
                    avatarURL = URL(string: mAvatar)
                }
            }
        }
        guard let url = avatarURL else {
            self.avatarImage.value = UIImage(named: "userAvatar")
            return
        }
        // let imageProcess = RoundCornerImageProcessor(cornerRadius: 17, targetSize: CGSize(width: 35, height: 35), roundingCorners: .all, backgroundColor: .clear)
        let ops: KingfisherOptionsInfo = [.fromMemoryCacheOrRefresh]
                                          //.processor(imageProcess),
                                          //.scaleFactor(2)]
        ImageDownloader.default.downloadImage(with: url,
                                              retrieveImageTask: nil,
                                              options: ops,
                                              progressBlock: nil,
                                              completionHandler: { [weak self] image, _, _, _ in
                                                if let mImage = image {
                                                    if let cropImage = mImage.cropImageToSquare?.roundedImage {
                                                        self?.avatarImage.value = cropImage
                                                    }
                                                }
        })
    }
    
    
}

public class ConversationTextMessageViewModelBuilder: ViewModelBuilderProtocol {
    
    var user: UserModel?
    var host: UserModel?
    
    public init() {
        
    }
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(_ textMessage: ConversationTextMessageModel) -> ConversationTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = ConversationTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.user = self.user
        textMessageViewModel.host = self.host
        //textMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return textMessageViewModel
    }
    
    public func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is ConversationTextMessageModel
    }
    
}

extension UIImage {
    
    var roundedImage: UIImage? {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? nil
    }
    
    var cropImageToSquare: UIImage? {
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
        }
        
        return self
    }
    
}
