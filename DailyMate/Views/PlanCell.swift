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
                    .frame(width: 80)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                Text(plan?.content ?? "내용")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                Text(plan?.point ?? "점수")
                
                
                
                
                
                
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
            }
            Divider()
        }
    }
}

