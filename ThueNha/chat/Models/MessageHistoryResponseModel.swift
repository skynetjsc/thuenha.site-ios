//
//  MessageHistoryResponseModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

protocol MessageHistoryResponseModelProtocol: BaseResponseModelProtocol where ResponseData == MessageHistoryModel {
    
}

struct MessageHistoryResponseModel: Codable, MessageHistoryResponseModelProtocol {
    var data: MessageHistoryModel
    var errorId: Int
    var message: String
}

protocol MessageHistoryModelProtocol {
    var id: String? { get set }
    var idUser: String? { get set }
    var idHost: String? { get set }
    var idPost: String? { get set }
    var content: [ChatMessageModel]? { get set }
    var isRead: String? { get set }
    var timeUpdated: String? { get set }
    var active: String? { get set }
    var post: PostModel? { get set }
    var avatarUser: String? { get set }
    var nameUser: String? { get set }
    var avatarHost: String? { get set }
    var nameHost: String? { get set }
}

struct MessageHistoryModel: Codable, MessageHistoryModelProtocol {
    var id: String?
    var idUser: String?
    var idHost: String?
    var idPost: String?
    var content: [ChatMessageModel]?
    var isRead: String?
    var timeUpdated: String?
    var active: String?
    var post: PostModel?
    var avatarUser: String?
    var nameUser: String?
    var avatarHost: String?
    var nameHost: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case idUser = "id_user"
        case idHost = "id_host"
        case idPost = "id_post"
        case content
        case isRead = "is_read"
        case timeUpdated = "time_updated"
        case active
        case post
        case avatarUser = "avatar_user"
        case nameUser = "name_user"
        case avatarHost = "avatar_host"
        case nameHost = "name_host"
    }
}

protocol PostModelProtocol {
    var id: String { get set }
    var hostId: String { get set }
    var idService: String { get set }
    var title: String { get set }
    var address: String { get set }
    var cityId: String { get set }
    var districtId: String { get set }
    var area: String { get set }
    var price: String { get set }
    var content: String { get set }
    var idUtility: String { get set }
    var note: String { get set }
    var avatar: String { get set }
    var date: String { get set }
    var type: String { get set }
    var numberBed: String { get set }
    var numberWC: String { get set }
    var active: String { get set }
}

struct PostModel: Codable, PostModelProtocol {
    var id: String
    var hostId: String
    var idService: String
    var title: String
    var address: String
    var cityId: String
    var districtId: String
    var area: String
    var price: String
    var content: String
    var idUtility: String
    var note: String
    var avatar: String
    var date: String
    var type: String
    var numberBed: String
    var numberWC: String
    var active: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case hostId = "host_id"
        case idService = "id_service"
        case title
        case address
        case cityId = "city_id"
        case districtId = "district_id"
        case area
        case price
        case content
        case idUtility = "id_utility"
        case note
        case avatar
        case date
        case type
        case numberBed = "number_bed"
        case numberWC = "number_wc"
        case active
    }
}
