//
//  DetailView.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/4/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    let item: Item
    
    var body: some View {
        VStack {
            Text("오늘의 우선순위")
            Button(action: {
                dismiss()
            }) {
                Label("일정추가", systemImage: "plus")
                
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(dateFormatter.string(from: item.timestamp))
                    Text(item.title)
                }
                .font(.title)
            }
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
        DetailView(item: Item(timestamp: Date(), title: "오늘은"))
    }
}
