//
//  ConversationPhotoMessageModel.swift
//  ThueNha
//
//  Created by Hồng Vũ on 12/16/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Chatto
import ChattoAdditions

class ConversationPhotoMessageModel: PhotoMessageModel<MessageModel> {
    
    var postModel: PostModel!
    
    public override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
    }

}
