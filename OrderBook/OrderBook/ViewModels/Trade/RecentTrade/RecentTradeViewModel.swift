//
//  RecentTradeViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Combine
import Foundation
import Factory
import Interactors
import Entities
import SwiftUI

public protocol RecentTradeViewModelProtocol: ObservableObject {
    var loading: Bool { get }
    var recentTradeViewModels: [TradeItemViewModel] { get } // TODO: shoudl use protocol?
	func subscribeTrade()
}

public final class RecentTradeViewModel: RecentTradeViewModelProtocol {
    @Published public var loading: Bool = true
    @Published public var recentTradeViewModels: [TradeItemViewModel] = []
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol
    private var lastTimestamp = ""
    private var cancellable = Set<AnyCancellable>()

    public init() {
        observeRecentTrade()
    }

    public func subscribeTrade() {
        marketDataInteractor.subscribe(topics: ["trade:XBTUSD"])
    }

    func observeRecentTrade() {
        // TODO: weak self
        marketDataInteractor.tradeValueSubject.sink { recentTrade in
            let recentTradeViewModels = recentTrade.map { tradeItem in
                return TradeItemViewModel(
                    sideColor: tradeItem.side.color,
                    price: "\(tradeItem.price)",
                    size: "\(tradeItem.size)",
                    timestamp: tradeItem.timestamp,
                    fillBackground: tradeItem.timestamp > self.lastTimestamp)
            }
            self.lastTimestamp = recentTrade.first?.timestamp ?? ""
            Task { @MainActor in
                self.recentTradeViewModels = recentTradeViewModels
            }
        }.store(in: &cancellable)
    }
}

extension Side {
    var color: Color {
        switch self {
        case .buy:
            return .green
        case .sell:
            return .red
        }
    }
}
