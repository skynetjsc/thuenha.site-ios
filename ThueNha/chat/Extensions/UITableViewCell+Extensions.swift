//
//  Reusable.swift
//  AerTrakOperator
//
//  Created by LTD on 11/21/18.
//  Copyright © 2018 Aeris. All rights reserved.
//

import UIKit

public protocol Reusable: class, NSObjectProtocol {
    static var reusableIdentifier: String { get }
}

public extension Reusable {
    public static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
}

public protocol Nibable: class, NSObjectProtocol {
    static var nib: UINib { get }
    static var nibName: String { get }
}

public extension Nibable {
    
    public static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle(for: self))
    }
    
    public static var nibName: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable, Nibable {
    
}

extension UICollectionReusableView: Reusable, Nibable {
    
}
