//
//  DecimalHelper.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation

public struct DecimalHelper {
    public static func format(_ value: Decimal, precision: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = precision
        formatter.minimumFractionDigits = precision
        return formatter.string(from: value as NSDecimalNumber) ?? ""
    }
}

public struct SizeHelper {
    public static func calculateSize
	(
		totalBuyVolume: Decimal,
		totalSellVolume: Decimal,
		accumulatedVolume: Decimal
	) -> CGFloat {
		let totalVolume = max(totalBuyVolume, totalSellVolume)
		let size = accumulatedVolume / totalVolume
		return CGFloat(truncating: size as NSNumber)
	}
}