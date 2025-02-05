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
    
    @State private var showingPriorityView: Bool = false
    @State private var showingPlanView: Bool = false
    
    let item: DayItem
    
    @State private var goodText: String
    @State private var badText: String
    
    @State private var priorityMode: PriorityEditMode = .create
    @State private var planMode: PlanEditMode = .create
    
    init(item: DayItem) {
        self.item = item
        // 초기값 설정
        _goodText = State(initialValue: item.good)
        _badText = State(initialValue: item.bad)
    }
    
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
                                priorityMode = .create
                                showingPriorityView = true
                            }, label: {
                                Label("", systemImage: "plus")
                            })
                            .offset(y: -2)
                            .foregroundStyle(.black)
                        }
                    }
                    .padding(12)
                    
                    ForEach(item.priority.indices, id: \.self) { index in
                        Text("\(index + 1). \(item.priority[index])")
                            .onTapGesture {
                                priorityMode = .update(item.priority[index])
                                showingPriorityView = true
                            }
                    }
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGray6))
                }
                
                Button(action: {
                    planMode = .create
                    showingPlanView = true
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
                    
                    if item.plan.isEmpty {
                        Text("등록된 일정이 없습니다.")
                            .frame(maxHeight: .infinity)
                            .padding()
                    }
                    
                    ForEach(item.plan) { plan in
                        PlanCell(plan: plan)
                            .onTapGesture {
                                planMode = .update(plan)
                                showingPlanView = true
                            }
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
                //                HStack {
                //                    TextEditor(text: $goodText)
                //                        .clipShape(.rect(cornerRadius: 8))
                //                        .overlay(content: {
                //                            RoundedRectangle(cornerRadius: 12)
                //                                .fill(Color(UIColor.systemGray6))
                //                        })
                //
                //                    TextEditor(text: $badText)
                //                        .clipShape(.rect(cornerRadius: 8))
                //                        .overlay(content: {
                //                            RoundedRectangle(cornerRadius: 12)
                //                                .fill(Color(UIColor.systemGray6))
                //                        })
                //                }
                //                .frame(height: 150)
                
                Spacer()
            }
        }
        .scrollContentBackground(.hidden)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dateFormatter.string(from: item.timestamp))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료", action: {
                    dismiss()
                })
                .foregroundStyle(.black)
            }
        }
        .sheet(isPresented: $showingPriorityView, content: {
            PriorityView(item: item, mode: priorityMode)
                .presentationDetents([.height(50)])
                .ignoresSafeArea(.keyboard, edges: .bottom)
        })
        .sheet(isPresented: $showingPlanView, content: {
            PlanView(item: item, mode: planMode)
                .presentationDetents([.height(300)])
                .ignoresSafeArea(.keyboard, edges: .bottom)
        })
        
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
