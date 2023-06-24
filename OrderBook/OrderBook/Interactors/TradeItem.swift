//
//  RecentTradeItem.swift
//  Interactors
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation
import Entities

public struct TradeItem {
    public var side: Side
    public var price: Decimal
    public var size: Decimal
    public var timestamp: String

    init(side: Side, price: Decimal, size: Decimal, timestamp: String) {
        self.side = side
        self.price = price
        self.size = size
        self.timestamp = timestamp
    }
}
