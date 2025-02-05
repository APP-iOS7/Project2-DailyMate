//
//  Schedule.swift
//  DailyMate
//
//  Created by 맨태 on 2/5/25.
//

import Foundation

struct Plan: Codable, Identifiable {
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
