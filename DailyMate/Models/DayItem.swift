//
//  Item.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import Foundation
import SwiftData

@Model
final class DayItem: Identifiable {
    var id: UUID
    var timestamp: Date
    var title: String
    var priority: [String]
    var plan: [Plan]
    var good: String
    var bad: String

    init(timestamp: Date, title: String, priority: [String] = [], plan: [Plan]=[], good: String = "", bad: String = "") {
        self.id = UUID()
        self.title = title
        self.priority = []
        self.plan = []
        self.good = good
        self.bad = bad
        
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: timestamp)
        components.hour = 9
        components.minute = 0
        components.second = 0
        self.timestamp = Calendar.current.date(from: components) ?? timestamp
    }
}
