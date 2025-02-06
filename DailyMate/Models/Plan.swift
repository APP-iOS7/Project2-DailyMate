//
//  Plan.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import Foundation
import SwiftData

@Model
final class Plan: Identifiable {
    var id: String
    var start: Date
    var end: Date
    var content: String
    var point: String
    
    var time: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return "\(formatter.string(from: start))/\n   \(formatter.string(from: end))"
    }
    
    init(id: String = UUID().uuidString, start: Date, end: Date, content: String, point: String) {
        self.id = id
        self.start = start
        self.end = end
        self.content = content
        self.point = point
    }
}
