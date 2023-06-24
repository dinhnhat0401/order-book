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

    enum CodingKeys: String, CodingKey {
        case table = "table"
        case action = "action"
        case data = "data"
    }
}

public struct TradeData: Decodable {
    public let timestamp: String
    public let symbol: String
    public let side: Side
    public let size: UInt64
    public let price: Decimal

    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case symbol = "symbol"
        case side = "side"
        case size = "size"
        case price = "price"
    }
}
