//
//  UINib+Extensions.swift
//  AerTrakOperator
//
//  Created by LTD on 11/21/18.
//  Copyright © 2018 Aeris. All rights reserved.
//

import UIKit

extension UINib {
    
    class func nibWithName(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}
