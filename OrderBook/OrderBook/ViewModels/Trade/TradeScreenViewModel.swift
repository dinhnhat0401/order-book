//
//  TradeScreenViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Factory
import Foundation
import Interactors

public protocol TradeScreenViewModelProtocol: ObservableObject {
    var orderBookViewModel: any OrderBookViewModelProtocol { get }
    var recentTradeViewModel: any RecentTradeViewModelProtocol { get }
}

public class TradeScreenViewModel: TradeScreenViewModelProtocol {
    public var orderBookViewModel: any OrderBookViewModelProtocol
    public var recentTradeViewModel: any RecentTradeViewModelProtocol
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol

    public init() {
        self.orderBookViewModel = OrderBookViewModel()
        self.recentTradeViewModel = RecentTradeViewModel()
        marketDataInteractor.connect()
        self.orderBookViewModel.subscribeOrderBook()
        self.recentTradeViewModel.subscribeTrade()
    }

    deinit {
        marketDataInteractor.disconnect()
    }
}
