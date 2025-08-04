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
    private var animationTimer: Timer?

    init(config: SpeedometerConfig = .init()) {
        self.config = config
        self.gaugeViewModel = GaugeViewModel(ticks: config.ticks, max: config.maxValue)
    }

    func submit(input: Double) {
        let clamped = min(input, config.maxValue)
        formattedInput = SpeedFormatter.format(input)
        formattedClamped = SpeedFormatter.format(clamped)
        animateTo(clamped)
    }

    private func animateTo(_ target: Double) {
        animationTimer?.invalidate()

        let start = gaugeValue.clampedValue
        let delta = target - start
        let middle = start + delta * 0.6

        let totalSteps = 60
        let phase1Steps = Int(Double(totalSteps) * 0.4)
        let phase2Steps = totalSteps - phase1Steps

        let duration = min(max(abs(delta) / 20000.0, 0.5), 2.5)
        let interval = duration / Double(totalSteps)

        var step = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if step >= phase1Steps {
                timer.invalidate()
                self.animatePhase2(from: middle, to: target, steps: phase2Steps, interval: interval)
                return
            }

            let t = Double(step) / Double(phase1Steps)
            let eased = start + (middle - start) * pow(t, 2) // ease-in
            self.updateGauge(animatedValue: eased, target: target)
            step += 1
        }
    }

    private func animatePhase2(from start: Double, to end: Double, steps: Int, interval: TimeInterval) {
        var step = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if step >= steps {
                timer.invalidate()
                self.updateGauge(animatedValue: end, target: end)
                return
            }

            let t = Double(step) / Double(steps)
            let eased = start + (end - start) * (1 - pow(1 - t, 2)) // ease-out
            self.updateGauge(animatedValue: eased, target: end)
            step += 1
        }
    }

    private func updateGauge(animatedValue: Double, target: Double) {
        self.gaugeValue = GaugeValue(inputValue: target, clampedValue: animatedValue)
        self.formattedInput = SpeedFormatter.format(target)
        self.formattedClamped = SpeedFormatter.format(animatedValue)
    }
}
