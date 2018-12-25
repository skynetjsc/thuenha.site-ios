//
//  Mi.swift
//  GProject
//
//  Created by KieuVan & LeHuuDung on 3/24/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit
@objcMembers
open class Mi: NSObject
{
    public override init()
    {
        super.init()
    }
    
    public init(dictionary : NSDictionary)
    {
        super.init()
        var allKey = self.propertyNames()
        for  i in 0..<allKey.count
        {
            let key = allKey[i]
            if(dictionary[key] != nil)
            {
                if let value = dictionary[key]
                {
                    if(!(value  is NSNull))
                    {
                        self.setValue(value , forKey: key )
                    }
                }
            }
        }
    }
    
    public func dictionary() ->Dictionary<String,Any>
    {
        var dict = Dictionary<String, Any>()
        let allKey = propertyNames()
        
        
        for  i in 0..<allKey.count
        {
            dict[allKey[i]] = value(forKey: allKey[i])

        }
        return dict;
    }
    
     public func dictionarySkipKey(skipKey : [String]) ->Dictionary<String,Any >
    {
        var dict = Dictionary<String, Any>()
        let allKey = propertyNames()
        for  i in 0..<allKey.count
        {
            if((skipKey.index{$0 == allKey[i]}) != nil)
            {
                continue
            }
            dict[allKey[i]] = value(forKey: allKey[i])
        }
        return dict;
    }

}

public extension Mi
{
    public func propertyNames() -> [String]
    {
        return Mirror(reflecting: self).children.compactMap({
            $0.label
        })
    }
}

