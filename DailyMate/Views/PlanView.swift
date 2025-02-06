//
//  PlanView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import SwiftUI

enum PlanEditMode: Equatable {
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
    @Binding var mode: PlanEditMode
    
    let item: DayItem
    
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
            
            HStack {
                Button(action: addPlan, label: {
                    Text(mode == .create ? "추가하기" : "수정하기")
                        .foregroundStyle(.black)
                })
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemGray6))
                )
                
                if case .update = mode {
                    Button(action: removePlan, label: {
                        Text("삭제하기")
                            .foregroundStyle(.white)
                    })
                    .frame(width: 100, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.red.opacity(0.8))
                    )
                }
            }
        }
        .padding()
        .onAppear(perform: {
            switch mode {
            case .create:
                start = item.timestamp
                end = Calendar.current.date(byAdding: .hour, value: 1, to: item.timestamp) ?? item.timestamp
            case .update(let plan):
                start = plan.start
                end = plan.end
                content = plan.content
                point = plan.point
            }
        })
    }
    
    func addPlan() {
        let newPlan: Plan = Plan(start: start, end: end, content: content, point: point)
        
        switch mode {
        case .create:
            item.plans.append(newPlan)
            item.timestamp = end
        case .update(let oldPlan):
            if let index = item.plans.firstIndex(of: oldPlan) {
                item.plans[index] = newPlan
            }
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    func removePlan() {
        switch mode {
        case .create: return
        case .update(let oldPlan):
            if let index = item.plans.firstIndex(of: oldPlan) {
                item.plans.remove(at: index)
                try? modelContext.save()
            }
        }
        dismiss()
    }
}

