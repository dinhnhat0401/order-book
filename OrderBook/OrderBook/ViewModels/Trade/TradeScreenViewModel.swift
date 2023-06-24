//
//  TradeScreenViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation

public protocol TradeScreenViewModelProtocol: ObservableObject {
    var orderBookViewModel: OrderBookViewModel { get }
    var recentTradeViewModel: RecentTradeViewModel { get }
}

public class TradeScreenViewModel: TradeScreenViewModelProtocol {
    // TODO: protocol?
    public var orderBookViewModel: OrderBookViewModel
    public var recentTradeViewModel: RecentTradeViewModel

    public init() {
        self.orderBookViewModel = OrderBookViewModel()
        self.recentTradeViewModel = RecentTradeViewModel()
    }
}
