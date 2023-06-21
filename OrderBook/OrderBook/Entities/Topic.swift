//
//  Topic.swift
//  Entities
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

public enum Topic {
    case orderBook(symbol: String)
    case trades(symbol: String)

    public var rawValue: String {
        switch self {
        case .orderBook(let symbol):
            return "orderBookL2:\(symbol)"
        case .trades(let symbol):
            return "trade:\(symbol)"
        }
    }
}
