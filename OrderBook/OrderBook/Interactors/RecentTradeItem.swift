//
//  RecentTradeItem.swift
//  Interactors
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

// TODO: should this be in interactor or entities
import Foundation

struct TradeItem {
    var price: Decimal
    var size: Decimal
    var timestamp: String

    init(price: Decimal, size: Decimal, timestamp: String) {
        self.price = price
        self.size = size
        self.timestamp = timestamp
    }
}
