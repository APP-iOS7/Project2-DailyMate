//
//  Day.swift
//  DailyMate
//
//  Created by 맨태 on 2/5/25.
//

import Foundation

struct Day: Codable {
    private var time: Date
    private var priorities: [String]
    private var schedules: [Plan]
    private var good: String
    private var bad: String
}
