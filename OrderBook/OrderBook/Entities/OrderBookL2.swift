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
}

public struct OrderBookL2Data: Decodable {
    let symbol: String
    let id: UInt64
    let side: Side
    let size: UInt64
    let price: Double
    let timestamp: String
}
