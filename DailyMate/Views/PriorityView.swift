//
//  PriorityView.swift
//  DailyMate
//
//  Created by 맨태 on 2/5/25.
//

import SwiftUI

struct PriorityView: View {
    @State private var priority: String = ""
    @Binding var priorities: [String]
    @Environment(\.dismiss) private var dismiss
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
        .onAppear(perform: {
            //isTextFieldFocused = true
        })
    }
    
    func addPriority() {
        if (!priority.isEmpty) {
            priorities.append(priority)
            dismiss()
        }
    }
}

//#Preview {
//    PriorityView()
//}
