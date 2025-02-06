//
//  PreviewContainer.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import Foundation
import SwiftData

// 데이터를 가져다가 화면을 갯인하는 코드
@MainActor
class PreviewContainer {
    // 싱글톤 패턴
    static let shared: PreviewContainer = PreviewContainer()
    
    let container: ModelContainer
    
    init() {
        let schema = Schema([
            DayItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: true,
                                                    cloudKitDatabase: .none)
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertPreviewData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertPreviewData() {
        let today = Date()
        let calendar = Calendar.current
        // 예제 데이터 생성
        let items: [(String, Date)] = [
            ("프로젝트", today),
            ("코딩테스트", calendar.date(byAdding: .day, value: -1, to: today)!),
            ("바쁜주말", calendar.date(byAdding: .day, value: -2, to: today)!),
            ("프로젝트", calendar.date(byAdding: .day, value: -3, to: today)!),
            ("코딩테스트", calendar.date(byAdding: .day, value: -4, to: today)!),
            ("바쁜주말", calendar.date(byAdding: .day, value: -5, to: today)!),
            ("프로젝트", calendar.date(byAdding: .day, value: -6, to: today)!),
            ("코딩테스트", calendar.date(byAdding: .day, value: -7, to: today)!),
            ("바쁜주말", calendar.date(byAdding: .day, value: -8, to: today)!),
            ("바쁜주말", calendar.date(byAdding: .day, value: -9, to: today)!),
            ("프로젝트", calendar.date(byAdding: .day, value: -10, to: today)!),
            ("코딩테스트", calendar.date(byAdding: .day, value: -11, to: today)!),
            ("바쁜주말", calendar.date(byAdding: .day, value: -12, to: today)!)
        ]
        
        for (title, date) in items {
            let item = DayItem(timestamp: date, title: title)
            container.mainContext.insert(item)
        }
        
        
        // 변경사항을 저장
        try? container.mainContext.save()
    }
}
