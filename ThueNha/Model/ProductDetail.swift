//
//  ProductDetail.swift
//  ThueNha
//
//  Created by Vinh on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 "data": {
 "is_pay": 0,
 "is_favourite": 0,
 "post": {
 "id": "175",
 "host_id": "11",
 "id_service": "2",
 "title": "Cho thuê chung cư làm nhà ở hoặc vp",
 "city_id": "1",
 "district_id": "19",
 "area": "83",
 "price": "9000000",
 "content": "2 PN, 1 PK. căn góc thoáng mát. rất tiện làm văn phòng hoặc nhà ở",
 "id_utility": "",
 "note": "",
 "avatar": "http://thuenha.site/uploads/post/20181121_112301.jpg",
 "date": "2018-11-26 06:46:45",
 "type": "1",
 "number_bed": "2",
 "number_wc": "2",
 "active": "1"
 },
 "utility": [
 {
 "id": "3",
 "name": "Điều hòa",
 "position": "3",
 "img": "http://thuenha.site/uploads/utility/air-conditioner.png",
 "content": "C\\Users\\DuongKK\\Downloads\\svgtopng",
 "date": "2018-11-17 21:28:16",
 "active": "1",
 "number": "0"
 },
 {
 "id": "4",
 "name": "Chỗ để xe",
 "position": "4",
 "img": "http://thuenha.site/uploads/utility/car-parking.png",
 "content": "Chỗ để xe",
 "date": "2018-11-17 21:28:56",
 "active": "1",
 "number": "0"
 },
 {
 "id": "5",
 "name": "Bếp nấu ăn",
 "position": "5",
 "img": "http://thuenha.site/uploads/utility/fire.png",
 "content": "Bếp nấu ăn",
 "date": "2018-11-17 21:29:15",
 "active": "1",
 "number": "0"
 },
 {
 "id": "7",
 "name": "Internet",
 "position": "8",
 "img": "http://thuenha.site/uploads/utility/internet.png",
 "content": "Internet",
 "date": "2018-11-17 21:29:46",
 "active": "1",
 "number": "0"
 },
 {
 "id": "9",
 "name": "Phòng Vệ sinh",
 "position": "9",
 "img": "http://thuenha.site/uploads/utility/washroom.png",
 "content": "Phòng Vệ sinh",
 "date": "2018-11-17 21:30:41",
 "active": "1",
 "number": "0"
 }
 ],
 "price": "0",
 "city": "Hà Nội",
 "district": "Q. Nam Từ Liêm",
 "image": [
 "http://thuenha.site/uploads/post/20181121_112301.jpg",
 "http://thuenha.site/uploads/post/20181121_112925.jpg",
 "http://thuenha.site/uploads/post/20181121_112021.jpg"
 ],
 "image_test": [
 {
 "id": "268",
 "post_id": "175",
 "img": "http://thuenha.site/uploads/post/20181121_112301.jpg",
 "active": "1"
 },
 {
 "id": "269",
 "post_id": "175",
 "img": "http://thuenha.site/uploads/post/20181121_112925.jpg",
 "active": "1"
 },
 {
 "id": "270",
 "post_id": "175",
 "img": "http://thuenha.site/uploads/post/20181121_112021.jpg",
 "active": "1"
 }
 ]
 },
 "errorId": 200,
 "message": "Chi tiết tin đăng"
 }
 */

class Image: Mi {
    var id = ""
    var post_id = ""
    var img = ""
    var active = "1"
}

class ProductDetail: Mi {
    var is_pay = 0
    var is_favourite = 0
    var post: Post = Post()
    var host: Host = Host()
    var utility: [UtilityProductDetail] = [UtilityProductDetail]()
    var image: [String] = [String]()
    var image_test: [Image] = [Image]()
    var price = ""
    var city = ""
    var district = ""
    
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }

    class func list(value : [NSDictionary]) -> [ProductDetail]
    {
        var list : [ProductDetail] = []
        for item in value
        {
            let object = ProductDetail.init(dictionary: item)
            list.append(object)
        }
        return list
    }
}

class ProductDetail_Request: Mi {
    var user_id = ""
    var post_id = ""
    var type = ""
}

class Payment_Request: Mi {
    var user_id = ""
    var post_id = ""
}

class DeleteProduct_Request: Mi {
    var id = ""
}

class ImageProductDetail: Mi {
    var imgUrl = ""
}

class Post: Mi {
    var id = ""
    var address = ""
    var host_id = ""
    var id_service = ""
    var title = ""
    var city_id = ""
    var district_id = ""
    var area = ""
    var price = ""
    var content = ""
    var id_utility =  ""
    var note = ""
    var avatar = ""
    var date = ""
    var type = ""
    var number_bed = ""
    var number_wc = ""
    var active = ""
    subscript(key: String) -> Any? {
        return dictionary()[key]
    }

}

class Host: Mi {
    var id = ""
    var name = ""
    var email = ""
    var phone = ""
    var password = ""
    var avatar = ""
    var address = ""
    var account = ""
    var date = ""
    var active = ""
    var first_name = ""
    var last_name = ""
    var birthday = ""
    var gender = ""
    var number_post = ""
}

extension Services {
    func getProductDetail(param: ProductDetail_Request, success: @escaping((ProductDetail) -> Void), failure: @escaping((APIResponse) -> Void)) {
        services.request(api: .post_detail, method: .post, param: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let  productDetail = ProductDetail.init(dictionary: response.data as! NSDictionary)
            productDetail.utility = UtilityProductDetail.list(value: productDetail.utility as! [NSDictionary])
            let ppp = productDetail.post
            let jsonObj = JSON(response.data as! NSDictionary)
            let post = jsonObj["post"].object
            let host = jsonObj["host"].object
            productDetail.post = Post.init(dictionary: post as! NSDictionary)
            productDetail.host = Host.init(dictionary: host as? NSDictionary ?? NSDictionary())
            
            if let image_tests = jsonObj["image_test"].arrayObject {
                productDetail.image_test.removeAll()
                for image in image_tests {
                    let img = Image.init(dictionary: image as? NSDictionary ?? NSDictionary())
                    productDetail.image_test.append(img)
                }
            }
            
            
            success(productDetail)
        }) { (error) in
            failure(error)
        }
    }
    
    func getPaymentProductDetail(param: Payment_Request, success: @escaping(() -> Void), failure: @escaping((APIResponse) -> Void)){
        services.request(api: .pay_view, method: .post, param: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    func deleteProductDetail(param: DeleteProduct_Request, success: @escaping(() -> Void), failure: @escaping((APIResponse) -> Void)){
        services.request(api: .delete_post, method: .post, param: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            
            success()
        }) { (error) in
            failure(error)
        }
    }
}


