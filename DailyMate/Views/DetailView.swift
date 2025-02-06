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
    
    @State private var priorities: [String]
    @State private var plans: [Plan]
    @State private var goodText: String
    @State private var badText: String
    @State private var isEditingGood: Bool = false
    @State private var isEditingBad: Bool = false
    @State private var tempGoodText: String = ""
    @State private var tempBadText: String = ""
    @State private var showingPriorityView: Bool = false
    @State private var showingPlanView: Bool = false
    
    @State private var priorityMode: PriorityEditMode = .create
    @State private var planMode: PlanEditMode = .create
    
    init(item: DayItem) {
        self.item = item
        // 초기값 설정
        _goodText = State(initialValue: item.good)
        _badText = State(initialValue: item.bad)
        _priorities = State(initialValue: item.priority)
        _plans = State(initialValue: item.plan)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // VStack(alignment: .leading, spacing: 8) {
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
                            .offset(y: -2) // 
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
                
                VStack(spacing: 16) {
                    // Good Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("좋았던 점")
                                .font(.title2)
                            Spacer()
                            Button(action: {
                                tempGoodText = goodText
                                isEditingGood = true
                            }) {
                                Image(systemName: "pencil")
                            }
                            .foregroundStyle(.black)
                        }
                        
                        Text(goodText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 50)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                    // Bad Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("안좋았던 점")
                                .font(.title2)
                            Spacer()
                            Button(action: {
                                tempBadText = badText
                                isEditingBad = true
                            }) {
                                Image(systemName: "pencil")
                            }
                            .foregroundStyle(.black)
                        }
                        
                        Text(badText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 50)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical)
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dateFormatter.string(from: item.timestamp))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료", action: {
                    // 변경된 내용 저장
                    item.good = goodText
                    item.bad = badText
                    item.priority = priorities
                    item.plan = plans
                    try? modelContext.save()
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
        .sheet(isPresented: $isEditingGood) {
            NavigationStack {
                TextEditor(text: $tempGoodText)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .navigationTitle("좋았던 점 수정")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("취소") {
                                isEditingGood = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("확인") {
                                goodText = tempGoodText
                                isEditingGood = false
                            }
                        }
                    }
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isEditingBad) {
            NavigationStack {
                TextEditor(text: $tempBadText)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemGray6))
                     .overlay(
                         RoundedRectangle(cornerRadius: 8)
                             .stroke(Color.gray, lineWidth: 1)
                     )
                    .navigationTitle("안좋았던 점 수정")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("취소") {
                                isEditingBad = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("확인") {
                                badText = tempBadText
                                isEditingBad = false
                            }
                        }
                    }
            }
            .presentationDetents([.medium])
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
