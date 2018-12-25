//
//  ConversationTimeSeparatorModel.swift
//  ThueNha
//
//  Created by LTD on 12/8/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation
import UIKit
import Chatto

class ConversationTimeSeparatorModel: ChatItemProtocol {
    
    let uid: String
    let type: String = ConversationTimeSeparatorModel.chatItemType
    let date: String
    
    static var chatItemType: ChatItemType {
        return "ConversationTimeSeparatorModel"
    }
    
    init(uid: String, date: String) {
        self.date = date
        self.uid = uid
    }
}

extension Date {
    
    // Have a time stamp formatter to avoid keep creating new ones. This improves performance
    private static let weekdayAndDateStampDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE, MMM dd yyyy" // "Monday, Mar 7 2016"
        return dateFormatter
    }()
    
    func toWeekDayAndDateString() -> String {
        return Date.weekdayAndDateStampDateFormatter.string(from: self)
    }
}
