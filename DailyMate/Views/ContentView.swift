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
    @Query private var items: [DayItem]
    // 아이템 추가 알림 표시 여부
    @State private var isPresentingAddSheet = false
    // Error Alert(이미 오늘 날짜가 존재할 때) 표시 여부
    @State private var isPresentingErrorAlert = false
    // 새로운 아이템 제목
    @State private var newTitle: String = ""
    // 선택된 날짜
    @State private var selectedDate: Date = Date()
    // 상세 화면으로 이동 여부
    @State private var navigateToDetail: Bool = false
    // 새로운 아이템
    @State private var newItem: DayItem?
    // 삭제할 아이템
    @State private var itemToDelete: DayItem?
    // 삭제 확인 알림 표시 여부
    @State private var showingDeleteAlert = false
    
    @State private var showingAddDaily = false
    @State private var showingAlert = true // 네잎클로버 팝업 상태 추가
    @State private var isAlertPresented = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(UIColor.systemGray6)  // 가장 밝은 시스템 회색
                        .opacity(0.9)  // 더 연하게 만들기
                        .ignoresSafeArea()

                    List {
                        let sortedItems = items.sorted(by: {$0.timestamp > $1.timestamp})
                        ForEach(sortedItems) { item in
                            NavigationLink {
                                DetailView(item: item)
                            } label: {
                                HStack {
                                    Text(dateFormatter.string(from: item.timestamp))
                                    Text(item.title)
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            if let index = indexSet.first {
                                itemToDelete = sortedItems[index]
                                showingDeleteAlert = true
                            }
                        })
                    }
                    .scrollContentBackground(.hidden) 
                }
                // List의 기본 배경 숨기기
                .navigationTitle(Text("Daily Mate"))
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            isPresentingAddSheet = true // sheet 표시
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
                .alert("삭제 확인", isPresented: $showingDeleteAlert) {
                    Button("취소", role: .cancel) {
                        itemToDelete = nil
                    }
                    Button("삭제", role: .destructive) {
                        if let item = itemToDelete {
                            deleteItem(item)
                        }
                        itemToDelete = nil
                    }
                } message: {
                    Text("정말로 삭제하시겠습니까?")
                }
                .sheet(isPresented: $isPresentingAddSheet) {
                    NavigationStack {
                        Form {
                            TextField("제목", text: $newTitle)
                            DatePicker("날짜 선택",
                                    selection: $selectedDate,
                                    displayedComponents: .date)
                        }
                        .navigationTitle("날짜 추가")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("취소") {
                                    isPresentingAddSheet = false
                                    newTitle = ""
                                    selectedDate = Date()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("저장") {
                                    if hasItemForDate(selectedDate) {
                                        isPresentingErrorAlert = true
                                    } else {
                                        withAnimation {
                                            let item = DayItem(timestamp: selectedDate, title: newTitle, priority: [], plan: [], good: "", bad: "")
                                            modelContext.insert(item)
                                            try? modelContext.save()
                                            newItem = item
                                            navigateToDetail = true
                                        }
                                        isPresentingAddSheet = false
                                        newTitle = ""
                                        selectedDate = Date()
                                    }
                                }
                            }
                        }
                        .alert("해당 날짜는 이미 추가되었습니다.", isPresented: $isPresentingErrorAlert) {
                            Button("확인", role: .cancel) { }
                        } message: {
                            Text("하루에는 하나의 아이템만 추가할 수 있습니다.")
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToDetail) {
                    if let item = newItem {
                        DetailView(item: item)
                    }
                }
                
//                Spacer() // 리스트와 버튼 사이 간격 유지
            
            // 네잎클로버 버튼 (팝업 추가)
                HStack {
                    CloverButton(action: {
                        print("버튼 클릭됨!") // 디버깅용
                        isAlertPresented = true // 팝업 표시
                    })
                    .padding(.leading, 20) // 좌측 정렬
                    
                    Spacer() // 버튼을 좌측으로 밀기
                }
                .background(Color(UIColor.systemGray6).opacity(0.9).ignoresSafeArea())
            }
        }
        .alert("🍀 오늘의 행운 카드! 🍀", isPresented: $isAlertPresented) { //  Alert 추가
            Button("닫기", role: .cancel) { }
        } message: {
            Text("오늘은 특별한 행운이 찾아올 거예요! 😊")
        }
    }
    // DateFormatter를 하나 만들어 둔다.
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()
    
    // 특정 날짜에 해당하는 아이템이 이미 있는지 확인하는 함수
    private func hasItemForDate(_ date: Date) -> Bool {
        return items.contains { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
    }
    
    // 아이템 삭제하는 함수 수정
    private func deleteItem(_ item: DayItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewContainer.shared.container)
}
