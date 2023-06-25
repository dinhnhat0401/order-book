//
//  ViewModelHelper.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/25.
//

import Foundation

public struct ViewModelHelper {
    public static func format(_ value: Decimal) -> String {
        // Calculate precision dedpend on value
        let precision = max(caclulateNumberOfDigits(value), 1)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = precision
        formatter.minimumFractionDigits = precision
        return formatter.string(from: value as NSDecimalNumber) ?? ""
    }

    static func caclulateNumberOfDigits(_ value: Decimal) -> Int {
        // calculate number of digit after decimal point
        var result = 0
        var value = value
        while value < 1 {
            value *= 10
            result += 1
        }
        return result
    }
}
