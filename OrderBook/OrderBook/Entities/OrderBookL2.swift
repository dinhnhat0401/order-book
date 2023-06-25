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
    public let symbol: String
    public let id: UInt64
    public let side: Side
    public var size: UInt64? /// Delete records don't have size.
    public var price: Decimal
    public var timestamp: String

    init(symbol: String, id: UInt64, side: Side, size: UInt64? = nil, price: Decimal, timestamp: String) {
        self.symbol = symbol
        self.id = id
        self.side = side
        self.size = size
        self.price = price
        self.timestamp = timestamp
    }

    // Update data
    public mutating func updateData(size: UInt64, price: Decimal, timestamp: String) {
        self.size = size
        self.price = price
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case id = "id"
        case side = "side"
        case size = "size"
        case price = "price"
        case timestamp = "timestamp"
    }
}
