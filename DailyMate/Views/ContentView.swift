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
    @State private var luckyMessage: String = ""

    private let luckyMessages = [
        "오늘의 작은 미소가 내일의 큰 기쁨이 될 거예요. 희망을 잃지 말고 웃어보세요!",
        "매 순간 당신이 걷는 길은 기쁨으로 가득 찰 거예요. 자신을 믿고 전진하세요.",
        "하루가 길어 보일지라도, 한 걸음씩 나아가면 반드시 원하는 곳에 도달하게 될 거예요.",
        "새로운 시작은 늘 두렵지만, 그 끝에는 꿈에 한 발짝 더 가까워진 당신이 있어요.",
        "당신의 노력은 결코 헛되지 않아요. 보이지 않는 곳에서 행운이 함께하고 있답니다.",
        "작은 선행 하나가 커다란 행복이 되어 돌아올 거예요. 따스한 마음을 잃지 마세요.",
        "스스로를 믿는다면, 그 믿음이 행운의 문을 열어줄 거예요. 자신감을 가져봐요!",
        "눈앞의 어려움이 커 보여도, 그 너머엔 당신을 위한 소중한 기회가 기다리고 있어요.",
        "지금 맞이한 도전은 더 큰 행운을 위한 준비 과정일 뿐이에요. 힘내세요!",
        "당신이 쏟는 노력과 정성은 모두 다 빛나게 마련이에요. 언제나 행복과 행운이 함께하길!"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(UIColor.systemGray6)  // 가장 밝은 시스템 회색
                        .opacity(0.9)  // 더 연하게 만들기
                        .ignoresSafeArea()
                    
                    List {
                        // 아이템 목록 표시 - 날짜를 최근 날짜가 먼저 표시되도록 정렬
                        let sortedItems = items.sorted(by: {$0.timestamp > $1.timestamp})
                        ForEach(sortedItems) { item in
                            NavigationLink {
                                // 상세 화면으로 이동
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("DailyMate")
                            .font(.custom("Chalkboard SE", size: 40))
                            .bold()
                            .foregroundStyle(.green)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isPresentingAddSheet = true // sheet 표시
                        }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.green)
                                .bold()
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
                            .environment(\.locale, Locale(identifier: "ko_KR"))
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
                                .tint(.black)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("저장") {
                                    if hasItemForDate(selectedDate) {
                                        isPresentingErrorAlert = true
                                    } else {
                                        withAnimation {
                                            let item = DayItem(timestamp: selectedDate, title: newTitle, good: "", bad: "")
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
                                .tint(.green)
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
                        luckyMessage = luckyMessages.randomElement() ?? luckyMessages[0]
                        isAlertPresented = true // 팝업 표시
                    })
                    .padding(.leading, 20) // 좌측 정렬
                    
                    Spacer() // 버튼을 좌측으로 밀기
                }
                .background(Color(UIColor.systemGray6).opacity(0.9).ignoresSafeArea())
            }
            .alert("🍀 오늘의 행운 카드! 🍀", isPresented: $isAlertPresented) { //  Alert 추가
                Button("닫기", role: .cancel) { }
            } message: {
                Text(luckyMessage)
            }
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
