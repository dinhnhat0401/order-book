//
//  OrderBookItem.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation
import Entities

public struct OrderBookItem {
    public var buyPrice: Decimal
    public var buySize: Decimal
    public var buySizePercentage: Double
    public var sellPrice: Decimal
    public var sellSize: Decimal
    public var sellSizePercentage: Double

    public init(buyPrice: Decimal, buySize: Decimal, buySizePercentage: Double, sellPrice: Decimal, sellSize: Decimal, sellSizePercentage: Double) {
        self.buyPrice = buyPrice
        self.buySize = buySize
        self.buySizePercentage = buySizePercentage
        self.sellPrice = sellPrice
        self.sellSize = sellSize
        self.sellSizePercentage = sellSizePercentage
    }
}
