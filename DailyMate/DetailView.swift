//
//  DetailView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let item: DayItem
    
    @State private var goodText: String
    @State private var badText: String
    
    init(item: DayItem) {
        self.item = item
        // 초기값 설정
        _goodText = State(initialValue: item.good)
        _badText = State(initialValue: item.bad)
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ZStack {
                        Text("오늘의 우선순위")
                            .font(.title2)
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Label("", systemImage: "plus")
                            })
                            .foregroundStyle(.black)
                        }
                    }
                    .padding(12)
                    
                    Text("1. UI 야무지게 짜기")
                    Text("2. 앱 야무지게 개발하기")
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGray6))
                }
                
                Button(action: {
                    
                }, label: {
                    Text("일정 추가")
                        .frame(maxWidth: .infinity)
                })
                .frame(height: 50)
                .background{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemGray6))
                }
                .foregroundStyle(.black)
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("시간")
                    Spacer()
                    Divider()
                    Spacer()
                    Text("내용")
                    Spacer()
                    Divider()
                    Spacer()
                    Text("점수")
                    Spacer()
                }.frame(height: 40)
                
                List {
                    
                }
                
                VStack {
                    Text("Good")
                        .font(.title2)
                    Spacer()
                    TextEditor(text: $goodText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(Color(UIColor.systemGray6))
                    Text("Bad")
                        .font(.title2)
                    Spacer()
                    TextEditor(text: $badText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(Color(UIColor.systemGray6))
                }
                
                HStack {
                    
                }
            }
        }
        .scrollContentBackground(.hidden)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dateFormatter.string(from: item.timestamp))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료", action: {
                    // 변경된 내용 저장
                    item.good = goodText
                    item.bad = badText
                    try? modelContext.save()
                    dismiss()
                })
                .foregroundStyle(.black)
            }
        }
        
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
}

#Preview {
    NavigationStack {
        DetailView(item: DayItem(timestamp: Date(), title: "오늘은"))
    }
}
