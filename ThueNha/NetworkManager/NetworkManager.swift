import UIKit
import Alamofire
import SwiftyJSON
class NetworkManager {
    static let domain = "http://thuenha.site/api/"
    
    class var shareInstance : NetworkManager {
        struct Static {
            static let instance : NetworkManager = NetworkManager()
        }
        return Static.instance
    }
    
    func executeRequest(_ url: String,
                        _ method: HTTPMethod = .get,
                        _ params: Parameters? = nil,
                        _ encoding: ParameterEncoding = URLEncoding.queryString,
                        _ header: HTTPHeaders? = nil,
                        callBack: @escaping (Any,String, Bool) -> ()) {
        request(url,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: nil).responseJSON { (response) in
                    self.handleParseDataResponse(response, callBack: callBack)
        }
    }
    
    func handleParseDataResponse(_ response:DataResponse<Any>, callBack:@escaping (Any, String, Bool) -> ()) {
        let result = response.result
        var statusCode = -1
        if let responseCode = response.response {
            statusCode = responseCode.statusCode
        }
        switch result {
        case .success(let aData):
            if statusCode == 200 ||
                statusCode == 201 {
                let jsonData = JSON(aData)
                if let errnum = jsonData["errorId"].int {
                    if (errnum != 200) {
                        callBack(jsonData as Any, jsonData["message"].string ?? "", false)
                    } else {
                        callBack(jsonData["data"] as Any, jsonData["message"].string ?? "", true)
                    }
                } else {
                    callBack(result as Any,"", false)
                }
            } else {
                callBack(result as Any,"", false)
            }
            break
        case .failure( _):
            callBack(result as Any,"", false)
            break
        }
    }
    
    // http://thuenha.site/api/login.php
    func apiLogin(phone: String, password: String, type: String, callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params : Dictionary = ["username":phone, "password": password, "type": type] as Dictionary
        self.executeRequest(NetworkManager.domain + "login.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            if(isSuccess) {
                let saveData = JSON(["data":data])
                UserManager.user.saveUserData(saveData)
                UserManager.user.saveUserAuthen(password)
            }
            callBack(data, message, isSuccess)
        }
    }
    
    func apiRefreshLoginData(callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        self.apiLogin(phone: UserManager.user.phone(), password: UserManager.user.getUserAuthen(), type: String(UserManager.user.type()), callBack: callBack)
    }
    
    //    http://thuenha.site/api/service.php
    func apiGetServiceList(callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        self.executeRequest(NetworkManager.domain + "service.php") { (data, message, success) in
            callBack(data, message, success)
        }
    }
    
    //  http://thuenha.site/api/utility.php
    func apiGetUtilitiesList(callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        self.executeRequest(NetworkManager.domain + "utility.php") { (data, message, success) in
            callBack(data, message, success)
        }
    }
    
    //    http://thuenha.site/api/list_favourite.php?id=34
    func apiGetListFavourite(idUser: String, callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id":idUser] as Dictionary
        self.executeRequest(NetworkManager.domain + "list_favourite.php", .get, params, URLEncoding.queryString,  nil) { (data, message, isSuccess) in
            if (isSuccess) {
                let json = JSON(data).array
                var arrayNews : Array<MDNews> = []
                for i in 0..<json!.count {
                    let objNew = json![i]
                    var arrayUti : Array<MDUtility> = []
                    
                    for j in 0..<objNew["utility"].count {
                        let objUti = objNew["utility"][j]
                        let uti = MDUtility(utiID: objUti["id"].stringValue,
                                            utiName: objUti["id"].stringValue,
                                            utiImage: objUti["id"].stringValue,
                                            utiAvatar: objUti["id"].stringValue,
                                            utiContent: objUti["id"].stringValue,
                                            utiNumber: objUti["id"].stringValue,
                                            utiDate: objUti["id"].stringValue,
                                            utiActive: objUti["id"].stringValue,
                                            utiPosition: objUti["id"].stringValue)
                        arrayUti.append(uti)
                    }
                    if (objNew["id"].stringValue != "") {
                        let new = MDNews(address: objNew["address"].stringValue,
                                         city_id: objNew["city_id"].stringValue,
                                         id_service: objNew["id_service"].stringValue,
                                         type: objNew["type"].stringValue,
                                         id: objNew["id"].stringValue,
                                         date: objNew["date"].stringValue,
                                         host_id: objNew["host_id"].stringValue,
                                         content: objNew["content"].stringValue,
                                         area: objNew["area"].stringValue,
                                         note: objNew["note"].stringValue,
                                         number_bed: objNew["number_bed"].stringValue,
                                         avatar: objNew["avatar"].stringValue,
                                         active: objNew["active"].stringValue,
                                         arrayUti: arrayUti,
                                         price: objNew["price"].stringValue,
                                         id_utility: objNew["id_utility"].stringValue,
                                         number_wc: objNew["number_wc"].stringValue,
                                         district_id: objNew["district_id"].stringValue,
                                         title: objNew["title"].stringValue,
                                         number_seen: 0)
                        arrayNews.append(new)
                    }
                }
                callBack(arrayNews as Any, message, isSuccess)
            } else {
                callBack(data, message, isSuccess)
            }
        }
    }
    
    //    http://thuenha.site/api/list_post_host.php?id=34
    func apiGetListNewsExport(idUser: String, callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id":idUser] as Dictionary
        self.executeRequest(NetworkManager.domain + "list_post_host.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            if(isSuccess) {
                let json = JSON(data).array
                var arrayNews : Array<MDNews> = []
                for i in 0..<json!.count {
                    let objNew = json![i]
                    var arrayUti : Array<MDUtility> = []
                    
                    for j in 0..<objNew["utility"].count {
                        let objUti = objNew["utility"][j]
                        let uti = MDUtility(utiID: objUti["id"].stringValue,
                                            utiName: objUti["id"].stringValue,
                                            utiImage: objUti["id"].stringValue,
                                            utiAvatar: objUti["id"].stringValue,
                                            utiContent: objUti["id"].stringValue,
                                            utiNumber: objUti["id"].stringValue,
                                            utiDate: objUti["id"].stringValue,
                                            utiActive: objUti["id"].stringValue,
                                            utiPosition: objUti["id"].stringValue)
                        arrayUti.append(uti)
                    }
                    
                    let new = MDNews(address: objNew["address"].stringValue,
                                     city_id: objNew["city_id"].stringValue,
                                     id_service: objNew["id_service"].stringValue,
                                     type: objNew["type"].stringValue,
                                     id: objNew["id"].stringValue,
                                     date: objNew["date"].stringValue,
                                     host_id: objNew["host_id"].stringValue,
                                     content: objNew["content"].stringValue,
                                     area: objNew["area"].stringValue,
                                     note: objNew["note"].stringValue,
                                     number_bed: objNew["number_bed"].stringValue,
                                     avatar: objNew["avatar"].stringValue,
                                     active: objNew["active"].stringValue,
                                     arrayUti: arrayUti,
                                     price: objNew["price"].stringValue,
                                     id_utility: objNew["id_utility"].stringValue,
                                     number_wc: objNew["number_wc"].stringValue,
                                     district_id: objNew["district_id"].stringValue,
                                     title: objNew["title"].stringValue,
                                     number_seen: objNew["number_seen"].intValue)
                    arrayNews.append(new)
                }
                callBack(arrayNews as Any, message, isSuccess)
            }else {
                callBack(data, message, isSuccess)
            }
            
        }
    }
    
    //    http://thuenha.site/api/notification.php?id=34&type=1
    func apiGetListNotification( callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id":UserManager.user.id(), "type": UserManager.user.type()] as Dictionary
        self.executeRequest(NetworkManager.domain + "notification.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            if(isSuccess) {
                
                callBack(data, message, isSuccess)
            }else {
                callBack(data, message, isSuccess)
            }
            
        }
    }
    
    //    http://thuenha.site/api/notification_detail.php
    func apiGetListNotificationDetail(id:String, callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id":id, "user_id":UserManager.user.id(), "type": UserManager.user.type()] as Dictionary
        self.executeRequest(NetworkManager.domain + "notification_detail.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            if(isSuccess) {
                
                callBack(data, message, isSuccess)
            }else {
                callBack(data, message, isSuccess)
            }
            
        }
    }
    
    //    http://thuenha.site/api/favourite.php
    func apiPostFavorite(idUser:String, idPost: String, userType: Int, callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id_user":idUser, "id_post":idPost, "type": userType ] as Dictionary
        self.executeRequest(NetworkManager.domain + "favourite.php", .post, params, URLEncoding.default, nil) { (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/rent.php
    func apiRent(postId : String, hostId: String, userId:String = "", callBack:@escaping (Any, String, Bool) -> ()) -> Void {
        var params:Dictionary = ["host_id":hostId, "post_id":postId] as Dictionary
        if(userId.count > 0) {
            params["user_id"] = userId
        }
        self.executeRequest(NetworkManager.domain + "rent.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/city.php
    func apiGetCities(_ callBack:@escaping (Any, String, Bool) -> ()) -> Void {
        
        self.executeRequest(NetworkManager.domain + "city.php"){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/district.php
    func apiGetDistricts(_ cityId: String, callBack:@escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["city_id":cityId] as Dictionary
        self.executeRequest(NetworkManager.domain + "district.php", .get, params, URLEncoding.queryString, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/update_profile.php
    func apiUpdateProfile(_ email: String?, name: String?, address : String?, password : String?, callBack:@escaping (Any, String, Bool) -> ()) -> Void {
        var params:Dictionary = ["id":UserManager.user.id(), "type":UserManager.user.type()] as Dictionary
        
        if(email != nil && !email!.isEmpty) {
            params["email"] = email
        }
        
        if(name != nil && !name!.isEmpty) {
            params["name"] = name
        }
        
        if(address != nil && !address!.isEmpty) {
            params["address"] = address
        }
        
        if( password != nil && !password!.isEmpty) {
            params["password"] = password
        }
        self.executeRequest(NetworkManager.domain + "update_profile.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/update_avatar.php
    func apiUpdateAvatar(imageData : Data , updateProgress: @escaping (_ progress : Float) -> Void?, callBack:@escaping (Any, String, Bool) -> ()) -> Void {
        let id : String = UserManager.user.id()
        let type : String = String(UserManager.user.type())
        let imageName = String("\(UserManager.user.phone())_\(Date().timeIntervalSince1970).png")
        let params:Dictionary<String, String> = ["id":id, "type":type] as Dictionary
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName:"img" , fileName:imageName, mimeType: "image/*")
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key, mimeType: "text/plain")
            }
        }, usingThreshold: 10*1024*1024,
           to: NetworkManager.domain + "update_avatar.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    // success block
                    self.handleParseDataResponse(response, callBack: callBack)
                }
                
                upload.uploadProgress(closure: { (progress) in
                    updateProgress(Float(progress.completedUnitCount) /  Float(progress.totalUnitCount))
                    
                })
                
            case .failure(let encodingError):
                print("Failed to encode upload \(encodingError)")
            }
        }
    }
    
    //  http://thuenha.site/api/price.php
    func apiGetPrice(forService service : String, callBack: @escaping (Any, String, Bool) ->()) -> Void {
        let params:Dictionary = ["id_service":service] as Dictionary
        self.executeRequest(NetworkManager.domain + "price.php", .get, params, URLEncoding.queryString, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    // http://thuenha.site/api/delete_image.php
    func apiDeleteImage(_ id:String, callBack: @escaping (Any, String, Bool) ->()) -> Void {
        let params:Dictionary = ["id":id] as Dictionary
        self.executeRequest(NetworkManager.domain + "delete_image.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //  http://thuenha.site/api/feedback.php
    func apiPostFeedBack(content: String, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        let params:Dictionary = [
            "content":content,
            "type":UserManager.user.id(),
            "user_id":UserManager.user.id(),
            ] as Dictionary
        
        self.executeRequest(NetworkManager.domain + "feedback.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //  http://thuenha.site/api/like.php
    func apiLikeFeedBack(id: String, is_like: String, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        let params:Dictionary = [
            "id":id,
            "is_like":is_like,
            "type":UserManager.user.id(),
            "user_id":UserManager.user.id(),
            ] as Dictionary
        
        self.executeRequest(NetworkManager.domain + "like.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //  http://thuenha.site/api/comment.php
    func apiCommentFeedBack(id: String, comment: String, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        let params:Dictionary = [
            "id":id,
            "comment":comment,
            "type":UserManager.user.id(),
            "user_id":UserManager.user.id(),
            ] as Dictionary
        
        self.executeRequest(NetworkManager.domain + "comment.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //  http://thuenha.site/api/edit-post.php
    func apiEditPost(post id:String, service id_service: String, title titleText: String, price priceVal : String, withArea area:String, city city_id: String, district district_id: String, address addressText: String, content contentText:String, utility id_utility: Array<Dictionary<String, String>>, bed number_bed: String, wc number_wc: String, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        let params:Dictionary = [
            "id":id,
            "host_id":UserManager.user.id(),
            "id_service":id_service,
            "title": titleText,
            "price": priceVal,
            "area": area,
            "city_id": city_id,
            "district_id":district_id,
            "address":addressText,
            "content":contentText,
            "id_utility":JSON(id_utility),
            "number_bed":number_bed,
            "number_wc":number_wc
            ] as Dictionary
        
        self.executeRequest(NetworkManager.domain + "edit-post.php", .post, params, URLEncoding.default, nil){ (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //  http://thuenha.site/api/update_image.php
    func apiUpdateImagePost(_ id:String, images imageList: Array<Any>, updateProgress:@escaping (_ progress: Float) -> Void?, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for image in imageList {
                if let image = image as? UIImage {
                    var imageData: Data
                    var fileType: String
                    if(image.isPNG()) {
                        imageData = image.pngData()!
                        fileType = "png"
                    } else {
                        imageData = image.jpegData(compressionQuality: 1.0)!
                        fileType = "jpg"
                    }
                    let imageName = String("\(UserManager.user.phone())_\(Date().timeIntervalSince1970).\(fileType)")
                    multipartFormData.append(imageData, withName:"img[]" , fileName:imageName, mimeType: "image/*")
                }
                
            }
            
            multipartFormData.append(id.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "id", mimeType: "text/plain")
            
        }, usingThreshold: 10*1024*1024,
           to: NetworkManager.domain + "update_image.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    // success block
                    self.handleParseDataResponse(response, callBack: callBack)
                }
                
                upload.uploadProgress(closure: { (progress) in
                    updateProgress(Float(progress.completedUnitCount) /  Float(progress.totalUnitCount))
                    
                })
                
            case .failure(let encodingError):
                print("Failed to encode upload \(encodingError)")
            }
        }
    }
    
    //  http://thuenha.site/api/post.php
    func apiPost(service id_service: String, title titleText: String, price priceVal : String, withArea area:String, city city_id: String, district district_id: String, address addressText: String, content contentText:String, utility id_utility: Array<Dictionary<String, String>>, images imageList: Array<Any>, bed number_bed: String, wc number_wc: String, updateProgress:@escaping (_ progress: Float) -> Void?, callBack:@escaping (Any, String, Bool)->()) -> Void {
        
        let params:Dictionary = [
            "host_id":UserManager.user.id(),
            "id_service":id_service,
            "title": titleText,
            "price": priceVal,
            "area": area,
            "city_id": city_id,
            "district_id":district_id,
            "address":addressText,
            "content":contentText,
            "id_utility":JSON(id_utility),
            "number_bed":number_bed,
            "number_wc":number_wc
            ] as Dictionary
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for image in imageList {
                if let image = image as? UIImage {
                    var imageData: Data
                    var fileType: String
                    if(image.isPNG()) {
                        imageData = image.pngData()!
                        fileType = "png"
                    } else {
                        imageData = image.jpegData(compressionQuality: 1.0)!
                        fileType = "jpg"
                    }
                    let imageName = String("\(UserManager.user.phone())_\(Date().timeIntervalSince1970).\(fileType)")
                    multipartFormData.append(imageData, withName:"img[]" , fileName:imageName, mimeType: "image/*")
                }
                
            }
            
            for (key, value) in params {
                if(key == "id_utility") {
                    if let value = value as? JSON {
                        let sendData = value.rawString()
                        multipartFormData.append(sendData!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key, mimeType: "text/plain")
                    }
                } else {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key, mimeType: "text/plain")
                }
                
            }
        }, usingThreshold: 10*1024*1024,
           to: NetworkManager.domain + "post.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    // success block
                    self.handleParseDataResponse(response, callBack: callBack)
                }
                
                upload.uploadProgress(closure: { (progress) in
                    updateProgress(Float(progress.completedUnitCount) /  Float(progress.totalUnitCount))
                    
                })
                
            case .failure(let encodingError):
                print("Failed to encode upload \(encodingError)")
            }
        }
        
    }
    
    //  http://thuenha.site/api/list_view_post.php
    func apiGetListViewer(_ post_id: String, callBack: @escaping (Any, String, Bool)->()) -> Void {
        let params = ["id":post_id] as Dictionary
        self.executeRequest(NetworkManager.domain + "list_view_post.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            callBack(data, message, isSuccess)
        }
    }
    
    //    http://thuenha.site/api/list_feedback.php?user_id=34&type=1
    func apiGetListFeedBack( callBack: @escaping (Any, String, Bool) -> ()) -> Void {
        let params:Dictionary = ["id":UserManager.user.id(), "type": UserManager.user.type()] as Dictionary
        self.executeRequest(NetworkManager.domain + "list_feedback.php", .get, params, URLEncoding.queryString, nil) { (data, message, isSuccess) in
            if(isSuccess) {
                
                callBack(data, message, isSuccess)
            }else {
                callBack(data, message, isSuccess)
            }
            
        }
    }

    
}

