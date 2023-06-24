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
    var recentTradeViewModels: [TradeItemViewModel] { get } // TODO: shoudl use protocol?
}

public final class RecentTradeViewModel: RecentTradeViewModelProtocol {
    @Published public var recentTradeViewModels: [TradeItemViewModel] = []
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol
    private var cancellable = Set<AnyCancellable>()

    public init(topic: String = "trade:XBTUSD") {
        marketDataInteractor.connect()
        marketDataInteractor.subscribe(topics: [topic])
        observeRecentTrade()
    }

    func observeRecentTrade() {
//        Task { // TODO: weak self
//			for try await recentTrade in marketDataInteractor.streamRecentTrade() {
//                let recentTradeViewModels = recentTrade.map { tradeItem in
//                    return TradeItemViewModel(
//                        sideColor: tradeItem.side.color,
//                        price: "\(tradeItem.price)",
//                        size: "\(tradeItem.size)",
//                        timestamp: tradeItem.timestamp)
//                }
//                Task { @MainActor in
//                    self.recentTradeViewModels = recentTradeViewModels
//                }
//			}
//        }

        marketDataInteractor.tradeValueSubject.sink { recentTrade in
            let recentTradeViewModels = recentTrade.map { tradeItem in
                return TradeItemViewModel(
                    sideColor: tradeItem.side.color,
                    price: "\(tradeItem.price)",
                    size: "\(tradeItem.size)",
                    timestamp: tradeItem.timestamp,
                    fillBackground: true)
            }
            Task { @MainActor in
                self.recentTradeViewModels = recentTradeViewModels
//                // Do this after 0.2s
//                try! await Task.sleep(nanoseconds: 2_000_000_000)
//                self.recentTradeViewModels = self.recentTradeViewModels.map { vm in
//					let noFillVM = vm
//                    noFillVM.fillBackground = false
//					return noFillVM
//                }
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
