//
//  DayListCell.swift
//  DailyMate
//
//  Created by 맨태 on 2/4/25.
//

import SwiftUI

struct DayListCell: View {
    var time: String
    var content: String
    var point: String
    
    var body: some View {
        HStack {
            Text(time)
            Spacer()
            Text(content)
            Spacer()
            Text(point)
        }
    }
}

#Preview {
    DayListCell(time: "9:00\n  12:00", content: "앱 아이디어 생각하기", point: "70")
}
