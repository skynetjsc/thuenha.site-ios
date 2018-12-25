//
//  ListConversationWorker.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire

class ListConversationWorker {

    // MARK: - Business Logic

    func doSomeWork() {
        // TODO: Do the work
    }
    
    deinit {
        print("ListConversationWorker \(#function)")
    }
    
    func reqeustListConversation(idUser: Int, type: Int, completion: @escaping(ListConversationResponseModel?, Error?) -> Void) {
        let url = URL(string: "http://thuenha.site/api/list_chat.php?id_user=\(idUser)&type=\(type)")!
        Alamofire.request(url).responseDecodableObject { (response: DataResponse<ListConversationResponseModel>) in
            switch response.result {
            case .success(let data):
                completion(data, nil)
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    func requestDeleteConversation(idUser: String,
                                   idHost: String,
                                   idPost: String,
                                   completion: @escaping() -> Void) {
        let params: Parameters = ["id_user": idUser,
                                  "id_host": idHost,
                                  "id_post": idPost]
        Alamofire.request("http://thuenha.site/api/delete_message.php",
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default).responseDecodableObject { (response: DataResponse<MessageHistoryResponseModel>) in
                            switch response.result {
                            case .success(_):
                                completion()
                                break
                            case .failure(_):
                                completion()
                                break
                            }
        }
    }
    
    func requestConfirmRent(idUser: String,
                            idHost: String,
                            idPost: String,
                            completion: @escaping() -> Void) {
        let params: Parameters = ["user_id": idUser,
                                  "host_id": idHost,
                                  "post_id": idPost]
        Alamofire.request("http://thuenha.site/api/rent.php",
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default).responseDecodableObject { (response: DataResponse<MessageHistoryResponseModel>) in
                            switch response.result {
                            case .success(_):
                                completion()
                                break
                            case .failure(_):
                                completion()
                                break
                            }
        }
    }
}
