//
//  OrderBookViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Combine
import Factory
import Foundation
import Interactors

public protocol OrderBookViewModelProtocol: ObservableObject {
    var loading: Bool { get }
    var orderBookItemViewModels: [OrderBookItemViewModel] { get }
    func subscribeOrderBook()
}

public final class OrderBookViewModel: OrderBookViewModelProtocol {
    @Published public var orderBookItemViewModels: [OrderBookItemViewModel] = []
    @Published public var loading: Bool = true
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol
    private var cancellable = Set<AnyCancellable>()

    public init() {
        // TODO: skeleton or loading
        observeOrderBook()
    }

    public func subscribeOrderBook() {
        marketDataInteractor.subscribe(topics: ["orderBookL2:XBTUSD"])
    }

    func observeOrderBook() {
        marketDataInteractor.orderBookValueSubject.sink { orderBooks in
            let orderBookItemViewModels = orderBooks.map { orderBookItem in
                return OrderBookItemViewModel(
                    buyPrice: "\(orderBookItem.buyPrice)",
                    buySize: "\(orderBookItem.buySize)",
                    buySizePercentage: orderBookItem.buySizePercentage,
                    sellPrice: "\(orderBookItem.sellPrice)",
                    sellSize: "\(orderBookItem.sellSize)",
                    sellSizePercentage: orderBookItem.sellSizePercentage)
            }
            Task { @MainActor [weak self] in
                guard !orderBookItemViewModels.isEmpty else {
                    return
                }
                self?.loading = false
                self?.orderBookItemViewModels = orderBookItemViewModels
            }
        }.store(in: &cancellable)
    }
}
