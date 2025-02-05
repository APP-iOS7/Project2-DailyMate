//
//  PlanCell.swift
//  DailyMate
//
//  Created by Hyuk Ho Song on 2/5/25.
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

