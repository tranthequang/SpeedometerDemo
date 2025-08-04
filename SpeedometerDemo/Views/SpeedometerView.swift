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
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            ZStack {
                GaugeView(value: viewModel.gaugeValue.clampedValue, viewModel: viewModel.gaugeViewModel)
                VStack {
                    Text("\(viewModel.formattedInput)")
                        .foregroundStyle(ColorPalette.primaryColor)
                        .font(Font.custom("RobotoCondensed-Bold", size: 24))
                }
                .offset(y: 100)
            }
            .frame(height: 328)
        }
        .padding()
    }
}
