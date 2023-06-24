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
    var fillBackground: Bool { get set }
}

public final class TradeItemViewModel: TradeItemViewModelProtocol {
    @Published public var sideColor: Color
    @Published public var price: String
    @Published public var size: String
    @Published public var timestamp: String
    @Published public var fillBackground: Bool

    init(sideColor: Color, price: String, size: String, timestamp: String, fillBackground: Bool) {
        self.sideColor = sideColor
        self.price = price
        self.size = size
        self.timestamp = timestamp
        self.fillBackground = fillBackground
    }
}
