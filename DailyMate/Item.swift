//
//  Item.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: UUID
    var timestamp: Date
    var title: String
    init(timestamp: Date, title: String) {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
    }
}
