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
    var recentTradeViewModels: [TradeItemViewModel] { get }
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
		do {
        	try marketDataInteractor.subscribe(topics: ["trade:XBTUSD"])
		} catch {
			// Show error alert
		}
    }

    func observeRecentTrade() {
        marketDataInteractor.tradeValueSubject.sink { [weak self] recentTrade in
            let recentTradeViewModels = recentTrade.map { tradeItem in
                return TradeItemViewModel(
                    sideColor: tradeItem.side.color,
                    price: "\(ViewModelHelper.format(tradeItem.price))",
                    size: "\(ViewModelHelper.format(tradeItem.size))",
                    timestamp: tradeItem.timestamp,
                    fillBackground: tradeItem.timestamp > self?.lastTimestamp ?? "")
            }
            self?.lastTimestamp = recentTrade.first?.timestamp ?? ""
            Task { @MainActor [weak self] in
                guard !recentTradeViewModels.isEmpty else {
                    return
                }
                self?.loading = false
                self?.recentTradeViewModels = recentTradeViewModels
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
