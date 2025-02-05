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
    @Query private var item: [Item]
    
    @State private var showingAddDaily = false
    @State private var showingAlert = true // 네잎클로버 팝업 상태 추가
    @State private var isAlertPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(item) { item in
                        NavigationLink {
                            Text("\(item.title) at \(item.createdAt.formatted(Date.FormatStyle().year().month().day()))")
                        } label: {
                            Text("\(item.title) at \(item.createdAt.formatted(Date.FormatStyle().year().month().day()))")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("DailyMate")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: {
                            showingAddDaily = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                
                .sheet(isPresented: $showingAddDaily) {
                    AddDailyView()
                }
                
                Spacer() // 리스트와 버튼 사이 간격 유지
                
                // 네잎클로버 버튼 (팝업 추가)
                HStack {
                    CloverButton(action: {
                        print("버튼 클릭됨!") // 디버깅용
                        showingAlert = true // 팝업 표시
                    })
                    .padding(.leading, 20) // 좌측 정렬
                    
                    Spacer() // 버튼을 좌측으로 밀기
                }
                .padding(.bottom, 20) // 하단 여백 추가
            }
        }
        .alert("🍀 오늘의 행운 카드! 🍀", isPresented: $isAlertPresented) { //  Alert 추가
            Button("닫기", role: .cancel) { }
                } message: {
                    Text("오늘은 특별한 행운이 찾아올 거예요! 😊")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(item[index])
            }
        }
    }
}

// 네잎클로버 버튼
struct CloverButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: -25, y: -25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: 25, y: -25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: -25, y: 25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: 25, y: 25)
                
                Circle() // 가운데 원
                    .frame(width: 50, height: 50)
                
                // 중앙 텍스트 추가
                Text("행운 카드")
                    .font(.headline)
                    .foregroundColor(.white)
                
            }
            .frame(width: 120, height: 120) // 네잎클로버 전체 크기
            .background(Color.clear)
            .foregroundColor(.green) // 초록색 클로버
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

