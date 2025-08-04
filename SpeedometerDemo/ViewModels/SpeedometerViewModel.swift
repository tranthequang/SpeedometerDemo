//
//  SpeedometerViewModel.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//

import Foundation
import SwiftUI

class SpeedometerViewModel: ObservableObject {
    @Published var gaugeValue: GaugeValue = .init(inputValue: 0, clampedValue: 0)
    @Published var formattedInput: String = "0"
    @Published var formattedClamped: String = "0"

    let config: SpeedometerConfig
    let gaugeViewModel: GaugeViewModel

    init(config: SpeedometerConfig = .init()) {
        self.config = config
        self.gaugeViewModel = GaugeViewModel(ticks: config.ticks, max: config.maxValue)
    }

    func submit(input: Double) {
        let clamped = min(input, config.maxValue)
        gaugeValue = GaugeValue(inputValue: input, clampedValue: clamped)
        formattedInput = SpeedFormatter.format(input)
        formattedClamped = SpeedFormatter.format(clamped)
    }
}
