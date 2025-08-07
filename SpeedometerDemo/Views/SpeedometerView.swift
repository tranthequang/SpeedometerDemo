//
//  SpeedometerView.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//

import SwiftUI

struct SpeedometerView: View {
    @StateObject var viewModel = SpeedometerViewModel()
    @State private var inputText: String = ""
    @State private var animatedDisplayValue: Double = 0
    @State private var submittedValue: Double = 0

    var body: some View {
        VStack(spacing: 40) {
            HStack {
                TextField("Enter value", text: $inputText)
                    .keyboardType(UIKeyboardType.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 120)

                Button("Submit") {
                    if let value = Double(inputText) {
                        withAnimation(AnimationHelper.defaultAnimation(duration: viewModel.config.animationDuration)) {
                            viewModel.submit(input: value)
                        }
                        submittedValue = value
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            ZStack {
                GaugeView(value: viewModel.gaugeValue.clampedValue, viewModel: viewModel.gaugeViewModel)
                VStack {
                    Text(submittedValue > viewModel.config.maxValue ? SpeedFormatter.format(submittedValue) : SpeedFormatter.format(animatedDisplayValue))
                        .foregroundStyle(ColorPalette.primaryColor)
                        .font(Font.custom("RobotoCondensed-Bold", size: 24))
                }
                .offset(y: 75)
            }
            .frame(height: 328)
        }
        .padding()
        .onChange(of: viewModel.gaugeValue) { newGauge in
            if newGauge.inputValue <= viewModel.config.maxValue {
                animateDisplayValue(to: newGauge.inputValue)
            }
        }
    }

    private func animateDisplayValue(to target: Double) {
        let start = animatedDisplayValue
        let delta = target - start
        let steps = 30
        let duration = 0.6
        let interval = duration / Double(steps)

        var step = 0
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let t = Double(step) / Double(steps)
            let eased = start + delta * (1 - pow(1 - t, 2)) // ease-out

            animatedDisplayValue = eased

            step += 1
            if step > steps {
                timer.invalidate()
                animatedDisplayValue = target
            }
        }
    }
}
private extension String {
    func toDouble() -> Double? {
        Double(self)
    }
}
