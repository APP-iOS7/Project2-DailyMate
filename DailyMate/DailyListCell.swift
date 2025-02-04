//
//  DailyListCell.swift
//  DailyMate
//
//  Created by 맨태 on 2/4/25.
//

import SwiftUI

struct DailyListCell: View {
    var text: String = ""
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    DailyListCell()
}
