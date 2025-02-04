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
    
    @State private var isPresentingAddAlert = false
    
    /// Error Alert(이미 오늘 날짜가 존재할 때) 표시 여부
    @State private var isPresentingErrorAlert = false

    @State private var newTitle: String = ""
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(items.sorted(by: {$0.timestamp > $1.timestamp})) { item in
                        NavigationLink {
                            DetailView(item: item)
                        } label: {
                            HStack {
                                Text(dateFormatter.string(from: item.timestamp))
                                Text(item.title)
                            }
                            
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle(Text("Daily Mate"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: {
                            if hasItemForToday() {
                                isPresentingErrorAlert = true
                            } else {
                                isPresentingAddAlert = true
                            }
                        }) {
                            Label("Add Item", systemImage: "plus")
                            
                        }
                    }
                }
                .alert("오늘은 이미 추가되었습니다.", isPresented: $isPresentingErrorAlert) {
                    Button("확인", role: .cancel) { }
                } message: {
                    Text("하루에는 하나의 아이템만 추가할 수 있습니다.")
                }
                
                .alert("Add New Item", isPresented: $isPresentingAddAlert) {
                    TextField("Enter Title", text: $newTitle)
                    Button("Cancel", role: .cancel) {
                        // Alert 닫히면서 초기화
                        newTitle = ""
                    }
                    Button("Save") {
                        // 입력한 Title로 새 아이템 생성
                        withAnimation {
                            let newItem = Item(timestamp: Date(), title: newTitle)
                            modelContext.insert(newItem)
                        }
                        // Alert 닫히면서 초기화
                        newTitle = ""
                    }
                } message: {
                    Text("Please enter a title for the new item.")
                }
            }
//            .tabItem {
//                Label("날짜", Image(systemName: "calendar.circle.fill"))
//            }
//            Text("Hello, World!")
//                .tabItem {
//                    Label("행운메시지", Image(systemName: "bookmarks"))
//                }
        }
        
//
    }
    // DateFormatter를 하나 만들어 둔다.
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()
    /// 오늘 날짜에 해당하는 아이템이 이미 있는지 확인하는 함수
    private func hasItemForToday() -> Bool {
        // Swift에서 날짜 비교 시 Calendar를 이용하여 "연/월/일" 단위만 비교할 수 있음
        // isDateInToday()를 활용해도 됩니다.
        return items.contains { Calendar.current.isDateInToday($0.timestamp) }
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
//        .modelContainer(for: Item.self, inMemory: true)
        .modelContainer(PreviewContainer.shared.container)
}
