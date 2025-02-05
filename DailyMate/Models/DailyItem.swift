//
//  Item.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import Foundation
import SwiftData

@Model
final class DailyItem {
    var days: [Day] = []
    var drawTime: Date
    var luckyMessages: [String] = []
    
    init(timestamp: Date) {
        self.drawTime = timestamp
    }
}
