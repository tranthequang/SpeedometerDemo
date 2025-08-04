//
//  NeedleView.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//

import SwiftUI

struct NeedleView: View {
    var angle: Angle

    var body: some View {
        ZStack {
            Capsule()
                .fill(ColorPalette.primaryColor)
                .frame(width: 5, height: 80)
                .offset(y: -40)
        }
        .rotationEffect(angle, anchor: .center)
    }
}
