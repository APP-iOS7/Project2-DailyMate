//
//  DailyMateApp.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import SwiftUI
import SwiftData

@main
struct DailyMateApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DayItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // 앱의 문서 디렉토리에서 SwiftData 저장소 URL 얻기
        let url = URL.documentsDirectory.appendingPathComponent("DailyMate.store")
        
        // 기존 저장소 삭제
        try? FileManager.default.removeItem(at: url)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // 마지막 시도: 메모리에만 저장하는 설정으로 시도
            let inMemoryConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [inMemoryConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(sharedModelContainer)
    }
}
