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
    @Query private var dailyItems: [DailyItem]
    
    private var falseItems: [String] = ["2/4", "2/3", "2/2"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(falseItems, id: \.self) { item in
                    NavigationLink(value: "", label: {
                        DailyListCell(text: item)
                            
                    })
                }
                .listRowBackground(Color(UIColor.systemGray6))
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Text("Daily Mate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        
                    }, label: {
                        Label("", systemImage: "plus")
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
            //modelContext.insert()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                //modelContext.delete()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DailyItem.self, inMemory: true)
}
