//
//  Plan.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import Foundation
import SwiftData

struct Plan: Codable, Identifiable, Equatable {
    var id: String = UUID().uuidString
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
}
