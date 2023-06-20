//
//  OrderBookL2.swift
//  Models
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

struct OrderBookL2: Decodable {
    let table: String
    let action: Action
    let data: [OrderBookL2Data]
}

struct OrderBookL2Data: Decodable {
    let symbol: String
    let id: UInt64
    let side: Side
    let size: UInt64
    let price: Double
    let timestamp: String
}
