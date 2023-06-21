//
//  Trade.swift
//  Models
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

public struct Trade: MarketDataResponseProtocol, Decodable {
    public let table: String
    public let action: Action
    public let data: [TradeData]
}

public struct TradeData: Decodable {
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
