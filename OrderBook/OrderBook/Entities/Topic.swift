//
//  Topic.swift
//  Entities
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

public enum Topic: String {
    case orderBook(symbol: String) = "orderBookL2:\(symbol)"
    case trades(symbol: String) = "trade:\(symbol)"
}
