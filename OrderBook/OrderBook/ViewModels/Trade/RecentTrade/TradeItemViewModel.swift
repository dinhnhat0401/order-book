//
//  RecentTradeItemViewModel.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation
import SwiftUI

public protocol TradeItemViewModelProtocol: ObservableObject, Identifiable {
    var sideColor: Color { get }
    var price: String { get }
    var size: String { get }
    var timestamp: String { get }
}

public final class TradeItemViewModel: TradeItemViewModelProtocol {
    public var sideColor: Color
    public var price: String
    public var size: String
    public var timestamp: String

    init(sideColor: Color, price: String, size: String, timestamp: String) {
        self.sideColor = sideColor
        self.price = price
        self.size = size
        self.timestamp = timestamp
    }
}
