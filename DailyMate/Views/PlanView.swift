//
//  PlanView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import SwiftUI

enum PlanEditMode {
    case create
    case update(Plan)
}

struct PlanView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var content: String = ""
    @State private var point: String = ""
    let item: DayItem
    let mode: PlanEditMode
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                DatePicker("시작", selection: $start, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .fixedSize()
                DatePicker("종료", selection: $end, in: start..., displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .fixedSize()
                Spacer()
            }
            
            HStack(alignment: .top) {
                Text("내용")
                Spacer()
                TextEditor(text: $content)
                    .clipShape(.rect(cornerRadius: 12))
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray, lineWidth: 1)
                    )
            }
            
            HStack(spacing: 20) {
                Text("점수")
                TextField("100", text: $point)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(width: 80, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                    )
                Text("점")
                Spacer()
            }
            
            Button(action: addPlan, label: {
                Text("추가하기")
                    .foregroundStyle(.black)
            })
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .padding()
    }
    
    init(item: DayItem, mode: PlanEditMode) {
        self.item = item
        self.mode = mode
        
        switch mode {
        case .create: break
        case .update(let plan):
            _start = State(initialValue: plan.start)
            _end = State(initialValue: plan.end)
            _content = State(initialValue: plan.content)
            _point = State(initialValue: plan.point)
        }
    }
    
    func addPlan() {
        let newPlan: Plan = Plan(start: start, end: end, content: content, point: point)
        
        switch mode {
        case .create:
            item.plan.append(newPlan)
        case .update(let oldPlan):
            if let index = item.plan.firstIndex(of: oldPlan) {
                item.plan[index] = newPlan
            }
        }
        
        try? modelContext.save()
        dismiss()
    }
}

