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

    init(timestamp: Date, title: String, priority: [String] = [], plan: [Plan] = [], good: String = "", bad: String = "") {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
        self.priority = priority
        self.plan = plan
        self.good = good
        self.bad = bad
    }
}
