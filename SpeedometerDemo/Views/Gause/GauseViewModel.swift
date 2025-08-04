//
//  GauseViewModel.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//
import SwiftUI

class GaugeViewModel: ObservableObject {
    let ticks: [Double]
    let max: Double

    init(ticks: [Double], max: Double) {
        self.ticks = ticks
        self.max = max
    }

    func progress(for value: Double) -> Double {
        let clamped = min(Swift.max(value, 0), max)
        let pairs = Array(zip(ticks, ticks.dropFirst()))
        guard let segmentIndex = pairs.firstIndex(where: { clamped >= $0.0 && clamped <= $0.1 }) else { return 0 }
        let lower = ticks[segmentIndex]
        let upper = ticks[segmentIndex + 1]
        let localRatio = (clamped - lower) / (upper - lower)
        let globalRatio = (Double(segmentIndex) + localRatio) / Double(ticks.count - 1)
        return globalRatio
    }

    func needleAngle(for value: Double, startAngle: Double, sweepAngle: Double) -> Angle {
        let ratio = progress(for: value)
        return Angle(degrees: startAngle + sweepAngle * ratio)
    }

    func progressTrim(for value: Double, sweepAngle: Double) -> Double {
        let ratio = progress(for: value)
        return ratio * (sweepAngle / 360.0)
    }
}
