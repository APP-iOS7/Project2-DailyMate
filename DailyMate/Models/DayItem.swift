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
    var priorityString: String
    var plansData: String
    var good: String
    var bad: String
    
    var priorities: [String] {
        get {
            priorityString.components(separatedBy: ",").filter { !$0.isEmpty }
        }
        set {
            priorityString = newValue.joined(separator: ",")
        }
    }
    
    var plans: [Plan] {
            get {
                if let data = plansData.data(using: .utf8) {
                    do {
                        return try JSONDecoder().decode([Plan].self, from: data)
                    } catch {
                        print("Decoding error: ", error)
                        return []
                    }
                }
                return []
            }
            set {
                do {
                    let data = try JSONEncoder().encode(newValue)
                    if let string = String(data: data, encoding: .utf8) {
                        plansData = string
                    }
                } catch {
                    print("Encoding error: ", error)
                    plansData = "[]"
                }
            }
        }

    init(timestamp: Date, title: String, good: String = "", bad: String = "") {
        self.id = UUID()
        self.title = title
        self.good = good
        self.bad = bad
        self.plansData = "[]"
        self.priorityString = ""
        
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: timestamp)
        components.hour = 9
        components.minute = 0
        components.second = 0
        self.timestamp = Calendar.current.date(from: components) ?? timestamp
    }
}
