//
//  Trade.swift
//  Models
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

struct Trade: Decodable {
    let table: String
    let action: Action
    let data: [TradeData]
}

struct TradeData: Decodable {
    // TODO: remove unused properties
    let timestamp: String
    let symbol: String
    let side: Side
    let size: UInt64
    let price: Double
    let tickDirection: String
    let trdMatchID: String
    let grossValue: UInt64
    let homeNotional: Double
    let foreignNotional: Double
    let trdType: String
}
