//
//  MessageModel.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol ChatMessageModelProtocol {
    var sendFrom: String? { get set }
    var idUser: String? { get set }
    var idHost: String? { get set }
    var idPost: Int? { get set }
    var content: String? { get set }
    var type: Int? { get set }
    var attach: String? { get set }
    var time: String? { get set }
}

public struct ChatMessageModel: Codable, ChatMessageModelProtocol {
    
    public var sendFrom: String?
    public var idUser: String?
    public var idHost: String?
    public var idPost: Int?
    public var content: String?
    public var type: Int?
    public var attach: String?
    public var time: String?
    
    private enum CodingKeys: String, CodingKey {
        case sendFrom
        case idUser
        case idHost
        case idPost
        case content
        case type
        case attach
        case time
    }
    
    public init() {
        
    }
}
