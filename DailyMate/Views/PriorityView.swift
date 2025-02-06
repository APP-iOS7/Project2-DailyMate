//
//  PriorityView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import SwiftUI
import SwiftData

enum PriorityEditMode: Equatable {
    case create
    case update(String)
}

struct PriorityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var priority: String = ""
    var item: DayItem
    var mode: PriorityEditMode
    //@FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            TextField("우선순위를 입력하세요", text: $priority)
                //.focused($isTextFieldFocused)
            Button(action: addPriority, label: {
                Label("", systemImage: "paperplane")
            })
            .frame(width: 50, height: 50)
            .foregroundStyle(.black)
        }
        .padding(10)
    }
    
    init(item: DayItem, mode: PriorityEditMode) {
        self.item = item
        self.mode = mode
        
        switch mode {
        case .create: break
        case .update(let priority):
            _priority = State(initialValue: priority)
        }
    }
    
    func addPriority() {
        switch mode {
        case .create:
            if (!priority.isEmpty) { item.priority.append(priority) }
        case .update(let oldPriority):
            if let index = item.priority.firstIndex(of: oldPriority) {
                item.priority[index] = priority
            }
        }
        
        try? modelContext.save()
        dismiss()
    }
}
