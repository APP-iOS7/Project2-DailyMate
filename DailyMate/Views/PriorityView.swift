//
//  PriorityView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
//

import SwiftUI
import SwiftData

enum PriorityEditMode {
    case create
    case update(String)
}

struct PriorityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var priority: String = ""
    @Binding var mode: PriorityEditMode
    var item: DayItem
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            TextField("우선순위를 입력하세요", text: $priority)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($isTextFieldFocused)
            Button(action: addPriority, label: {
                Label("", systemImage: "paperplane")
            })
            .frame(width: 40, height: 40)
            .foregroundStyle(.black)
            
            if case .update = mode {
                Button(action: removePriority, label: {
                    Label("", systemImage: "trash")
                })
                .frame(width: 30, height: 40)
                .foregroundStyle(.red)
            }
        }
        .padding(10)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
            
            switch mode {
            case .create: break
            case .update(let oldValue):
                priority = oldValue
            }
        }
    }
    
    func addPriority() {
        switch mode {
        case .create:
            if (!priority.isEmpty) { item.priorities.append(priority) }
        case .update(let oldPriority):
            if let index = item.priorities.firstIndex(of: oldPriority) {
                item.priorities[index] = priority
            }
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    func removePriority() {
        switch mode {
        case .create: return
        case .update(let oldPriority):
            if let index = item.priorities.firstIndex(of: oldPriority) {
                item.priorities.remove(at: index)
                try? modelContext.save()
            }
        }
        
        dismiss()
    }
}
