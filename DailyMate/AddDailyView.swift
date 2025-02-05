//
//  AddDailyView.swift
//  DailyMate
//
//  Created by subin on 2/5/25.
//

import SwiftUI

struct AddDailyView: View {
    @Environment(\.modelContext) private var modelContext
    // 나를 호출한 뷰에서 닫기 기능을 동작 시키는 함수(클로저)
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                }
            }
            .navigationTitle("DailyMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let Daily = Item(title: title)
                        modelContext.insert(Daily)
                        dismiss()
                        
                    }
                }
            }
        }
    }
}

#Preview {
    AddDailyView()
}
