//
//  GaugeView.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//

import SwiftUI

struct GaugeView: View {
    var value: Double
    @ObservedObject var viewModel: GaugeViewModel
    
    private var progress: Double {
        min(value / viewModel.max, 1.0)
    }

    var body: some View {
        ZStack {
            let startAngle: Double = 250
            let sweepAngle: Double = 220
            
            Circle()
                .trim(from: 0.0, to: 1.0)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: ColorPalette.outerCircleGradient),
                        center: .center,
                        startRadius: 0,
                        endRadius: 180
                    )
                )
                .frame(width: 328, height: 328)
                .rotationEffect(.degrees(180))

            let progressTrim = viewModel.progressTrim(for: value, sweepAngle: sweepAngle)
            let needleAngle = viewModel.needleAngle(for: value, startAngle: startAngle, sweepAngle: sweepAngle)

            Circle()
                .trim(from: 0.0, to: progressTrim)
                .stroke(
                    ColorPalette.primaryColor,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(160))
                .frame(width: 318, height: 318)

            Circle()
                .trim(from: 0.0, to: 1.0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: ColorPalette.innerCircleGradient),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 310, height: 310)
                .rotationEffect(.degrees(180))
                .shadow(color: ColorPalette.shadow, radius: 3.0)

            Circle()
                .trim(from: 0.0, to: 1.0)
                .fill(Color.black)
                .frame(width: 61.8, height: 61.8)
                .rotationEffect(.degrees(180))
                .shadow(color: Color.black, radius: 3.0)
            
            ForEach(Array(viewModel.ticks.enumerated()), id: \.offset) { index, tick in
                let angle = Angle(degrees: startAngle + sweepAngle * Double(index) / Double(Swift.max(viewModel.ticks.count - 1, 1)))
                let suffix = (index == viewModel.ticks.count - 1) ? "+" : ""
                VStack {
                    Text("\(SpeedFormatter.format(tick))\(suffix)" )
                        .foregroundStyle(Color.white)
                        .font(Font.custom("RobotoCondensed-Bold", size: 16))
                        .rotationEffect(-angle)
                    Spacer()
                }
                .rotationEffect(angle)
                .frame(width: 280, height: 280)
            }

            NeedleView(angle: needleAngle)
                .frame(width: 124, height: 124)
        }
        .frame(width: 328, height: 328)
    }
}
