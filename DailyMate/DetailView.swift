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
    
    @State private var goodText: String = ""
    @State private var badText: String = ""
    
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
                    Divider()
                    Spacer()
                    Text("내용")
                    Spacer()
                    Divider()
                    Text("점수")
                    Spacer()
                }.frame(height: 40)
                
                List {
                    
                }
                
                VStack {
                    Text("좋았던 점")
                        .font(.title2)
                    Spacer()
                    TextEditor(text: $goodText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(Color(UIColor.systemGray6))
                    Text("나빴던 점")
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
        .navigationTitle("2월 4일")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료", action: {
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
