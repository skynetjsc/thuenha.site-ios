//
//  JSONEncoder+Extensions.swift
//  ThueNha
//
//  Created by LTD on 12/7/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

extension JSONEncoder {
    
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
    
}
