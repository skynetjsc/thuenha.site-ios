//
//  UITableViewExtension.swift
//  ReBook
//
//  Created by Lâm Phạm on 10/7/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import Foundation
import UIKit

let RefreshControlTag = 1212312

public extension UITableView {
    func pullToRefresh(selector: Selector) {
        let control = UIRefreshControl()
        control.tag = RefreshControlTag
        control.addTarget(target, action: selector, for: .valueChanged)
        control.attributedTitle = NSAttributedString(string: "Kéo xuống để tải lại dữ liệu")
        self.addSubview(control)
    }
    func stopRefresh() {
        for subview in self.subviews {
            if subview.tag == RefreshControlTag {
                (subview as! UIRefreshControl).endRefreshing()            }
        }
    }
}
