//
//  DayListCell.swift
//  DailyMate
//
//  Created by 맨태 on 2/4/25.
//

import SwiftUI

struct PlanCell: View {
    var plan: Plan?
    
    var body: some View {
        VStack {
            HStack {
                Text(plan?.time ?? "시간")
                Spacer()
                Text(plan?.content ?? "내용")
                Spacer()
                Text(plan?.point ?? "점수")
            }
            Divider()
        }
    }
}

//#Preview {
//    PlanCell()
//}
