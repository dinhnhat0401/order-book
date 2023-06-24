//
//  OrderBookViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Factory
import Foundation
import Interactors

public protocol OrderBookViewModelProtocol: ObservableObject {
    var orderBookItemViewModels: [OrderBookItemViewModel] { get }
}

public final class OrderBookViewModel: OrderBookViewModelProtocol {
    @Published public var orderBookItemViewModels: [OrderBookItemViewModel] = []
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol

    public init(topic: String = "orderBookL2:XBTUSD") {
        self.orderBookItemViewModels = [
            OrderBookItemViewModel(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4),
            OrderBookItemViewModel(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4),
            OrderBookItemViewModel(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4),
            OrderBookItemViewModel(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4),
        ]
        marketDataInteractor.connect()
        marketDataInteractor.subscribe(topics: [topic])
        observeOrderBook()

//        defer {
//            marketDataInteractor.disconnect()
//        }
    }

//    deinit {
//        marketDataInteractor.disconnect()
//    }

    func observeOrderBook() {
        Task { // TODO: weak self
            for try await orderBooks in self.marketDataInteractor.streamOrderBook() {
                let orderBookItemViewModels = orderBooks.map { orderBookItem in
                    return OrderBookItemViewModel(
                        buyPrice: "\(orderBookItem.buyPrice)",
                        buySize: "\(orderBookItem.buySize)",
                        buySizePercentage: orderBookItem.buySizePercentage,
                        sellPrice: "\(orderBookItem.sellPrice)",
                        sellSize: "\(orderBookItem.sellSize)",
                        sellSizePercentage: orderBookItem.sellSizePercentage)
                }

                Task { @MainActor in
                    self.orderBookItemViewModels = orderBookItemViewModels
                }
            }
        }
    }
}
