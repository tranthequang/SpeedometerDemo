//
//  SpeedFormatter.swift
//  SpeedometerDemo
//
//  Created by Tran The Quang on 4/8/25.
//

struct SpeedFormatter {
    static func format(_ value: Double) -> String {
        switch value {
        case 1_000_000...:
            let shortValue = value / 1_000_000
            if shortValue.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0fM", shortValue)
            } else {
                return String(format: "%.1fM", shortValue)
            }
        
        case 1_000...:
            let shortValue = value / 1_000
            if shortValue.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0fK", shortValue)
            } else {
                return String(format: "%.1fK", shortValue)
            }
        default:
            return String(format: "%.0f", value)
        }
    }
}
