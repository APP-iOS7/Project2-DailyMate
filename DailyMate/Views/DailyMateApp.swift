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
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DayItem.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // 오류 발생 시 새로운 설정으로 다시 시도
            let inMemoryConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
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
