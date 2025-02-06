//
//  CloverButton.swift
//  DailyMate
//
//  Created by 맨태 on 2/6/25.
//

import SwiftUI

struct CloverButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: -25, y: -25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: 25, y: -25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: -25, y: 25)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .offset(x: 25, y: 25)
                
                Circle() // 가운데 원
                    .frame(width: 50, height: 50)
                
                // 중앙 텍스트 추가
                Text("행운 카드")
                    .font(.headline)
                    .foregroundColor(.white)
                
            }
            .frame(width: 120, height: 120) // 네잎클로버 전체 크기
            .background(Color.clear)
            .foregroundColor(.green) // 초록색 클로버
        }
    }
}

