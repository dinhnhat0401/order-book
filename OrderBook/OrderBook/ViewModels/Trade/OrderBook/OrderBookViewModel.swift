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
        observeOrderBook()
    }

    public func subscribeOrderBook() {
        do {
            try marketDataInteractor.subscribe(topics: ["orderBookL2:XBTUSD"])
        } catch {
            // Show error alert
        }
    }

    func observeOrderBook() {
        marketDataInteractor.orderBookValueSubject.sink { orderBooks in
            let orderBookItemViewModels = orderBooks.map { orderBookItem in
                return OrderBookItemViewModel(
                    buyPrice: "\(ViewModelHelper.format(orderBookItem.buyPrice))",
                    buySize: "\(ViewModelHelper.format(orderBookItem.buySize))",
                    buySizePercentage: orderBookItem.buySizePercentage,
                    sellPrice: "\(ViewModelHelper.format(orderBookItem.sellPrice))",
                    sellSize: "\(ViewModelHelper.format(orderBookItem.sellSize))",
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
