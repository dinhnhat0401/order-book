//
//  OrderBookL2.swift
//  Models
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

public struct OrderBookL2: MarketDataResponseProtocol, Decodable {
    public let table: String
    public let action: Action
    public let data: [OrderBookL2Data]

    enum CodingKeys: String, CodingKey {
        case table = "table"
        case action = "action"
        case data = "data"
    }
}

public struct OrderBookL2Data: Decodable {
    let symbol: String
    let id: UInt64
    let side: Side
    let size: UInt64
    let price: Decimal
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case id = "id"
        case side = "side"
        case size = "size"
        case price = "price"
        case timestamp = "timestamp"
    }
}
