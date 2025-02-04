//
//  ContentView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    private var falseItems: [String] = ["2/4", "2/3", "2/2"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(falseItems, id: \.self) { item in
                    NavigationLink(value: "", label: {
                        DailyListCell(text: item)
                    })
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Text("Daily Mate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("", systemImage: "plus", action: {
                        
                    })
                    .tint(.black)
                })
            })
            .scrollContentBackground(.hidden)
            .navigationDestination(for: String.self) { _ in
                DayView()
            }
            
        }
        .padding(.top, 10)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
