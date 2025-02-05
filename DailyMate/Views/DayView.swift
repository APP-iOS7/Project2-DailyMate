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
    @State private var priorities: [String] = []
    @State private var plans: [Plan] = []
    @State private var showingPriorityView: Bool = false
    @State private var showingScheduleView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    ZStack {
                        Text("오늘의 우선순위")
                            .font(.title2)
                        HStack {
                            Spacer()
                            Button(action: {
                                showingPriorityView = true
                            }, label: {
                                Label("", systemImage: "plus")
                            })
                            .offset(y: -2)
                            .foregroundStyle(.black)
                        }
                    }
                    .padding(12)
                    
                    ForEach(priorities.indices, id: \.self) { index in
                        Text("\(index + 1). \(priorities[index])")
                    }
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGray6))
                }
                
                Button(action: {
                    showingScheduleView = true
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
                
                VStack(alignment: .leading, spacing: 8) {
                    PlanCell()
                    
                    if plans.isEmpty {
                        Text("등록된 일정이 없습니다.")
                            .frame(maxHeight: .infinity)
                            .padding()
                    }
                    
                    ForEach(plans) { plan in
                        PlanCell(plan: plan)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemGray6))
                )
                
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
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        })
                    
                    TextEditor(text: $badText)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        })
                }
                .frame(height: 150)
                
                Spacer()
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
        .sheet(isPresented: $showingPriorityView, content: {
            PriorityView(priorities: $priorities)
                .presentationDetents([.height(50)])
                .ignoresSafeArea(.keyboard, edges: .bottom)
        })
        .sheet(isPresented: $showingScheduleView, content: {
            PlanView(plans: $plans)
                .presentationDetents([.height(300)])
                .ignoresSafeArea(.keyboard, edges: .bottom)
        })
        
    }
}

#Preview {
    DayView()
}
