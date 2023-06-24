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

    public init?(rawValue: String) {
        let components = rawValue.components(separatedBy: ":")
        guard components.count == 2 else {
            return nil
        }

        let topic = components[0]
        let symbol = components[1]

        switch topic {
        case "orderBookL2":
            self = .orderBook(symbol: symbol)
        case "trade":
            self = .trades(symbol: symbol)
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .orderBook(let symbol):
            return "orderBookL2:\(symbol)"
        case .trades(let symbol):
            return "trade:\(symbol)"
        }
    }
}
