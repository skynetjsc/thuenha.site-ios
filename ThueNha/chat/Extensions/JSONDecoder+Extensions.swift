//
//  JSONDecoder+Extensions.swift
//  AerTrakOperatorDataAccess
//
//  Created by Hồng Vũ on 11/30/18.
//  Copyright © 2018 Aeris. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
