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
    var good: String
    var bad: String

    init(timestamp: Date, title: String, good: String = "", bad: String = "") {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
        self.good = good
        self.bad = bad
    }
}
