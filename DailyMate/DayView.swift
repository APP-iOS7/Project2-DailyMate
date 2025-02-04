//
//  DayView.swift
//  DailyMate
//
//  Created by 맨태 on 2/4/25.
//

import SwiftUI

struct DayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var goodText: String = ""
    @State private var badText: String = ""
    private var falseItems: [DayListCell] = [
        DayListCell(time: "시간", content: "내용", point: "점수"),
        DayListCell(time: "9:00/\n  10:00", content: "앱 아이디어 생각하기", point: "70"),
        DayListCell(time: "10:00/\n  12:00", content: "앱 UI 구성하기", point: "70"),
        DayListCell(time: "12:00/\n  13:00", content: "점심시간", point: "100")
    ]
    
    var body: some View {
        NavigationView {
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
                
                List {
                    ForEach(falseItems, id: \.time) { item in
                        DayListCell(time: item.time, content: item.content, point: item.point)
                            .listRowBackground(Color(UIColor.systemGray6))
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Good")
                        .font(.largeTitle)
                    Spacer()
                    Spacer()
                    Text("Bad")
                        .font(.largeTitle)
                    Spacer()
                }
                
                HStack {
                    TextEditor(text: $goodText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        .background(Color(UIColor.systemGray6))
                    
                    TextEditor(text: $badText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        .background(Color(UIColor.systemGray6))
                }
                .frame(height: 150)
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
        
}

#Preview {
    DayView()
}
