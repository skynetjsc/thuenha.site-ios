//
//  ConversationWorker.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire

class ConversationWorker {

    // MARK: - Business Logic
    
    deinit {
        print("ConversationWorker \(#function)")
    }
    
    func requestMessageHistory(idUser: String,
                               idHost: String,
                               idPost: String,
                               completion: @escaping(MessageHistoryResponseModel?, Error?) -> Void) {
        let params: Parameters = ["id_user": idUser,
                                  "id_host": idHost,
                                  "id_post": idPost]
        Alamofire.request("http://thuenha.site/api/get_message.php",
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default).responseDecodableObject { (response: DataResponse<MessageHistoryResponseModel>) in
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
    
    func requestMessage(idUser: String,
                        idHost: String,
                        idPost: String,
                        type: String,
                        content: String,
                        time: String,
                        attach: String,
                        completion: @escaping() -> Void) {
        let params: Parameters = ["id_user": idUser,
                                  "id_host": idHost,
                                  "id_post": idPost,
                                  "type": type,
                                  "content": content,
                                  "time": time,
                                  "attach": attach]
        Alamofire.request("http://thuenha.site/api/message.php",
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
