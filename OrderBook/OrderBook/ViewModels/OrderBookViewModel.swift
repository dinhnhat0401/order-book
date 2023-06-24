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
    var orderBookItems: [OrderBookItemViewModel] { get }
}

public final class OrderBookViewModel: OrderBookViewModelProtocol {
    @Published public var orderBookItems: [OrderBookItemViewModel] = []
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol

     public init() {
//         self.orderBookItems = orderBook.orderBookItems.map { OrderBookItemViewModel(orderBookItem: $0) }
         self.orderBookItems = [
            OrderBookItemViewModel(orderBookItem: OrderBookItem(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4))
         ]
     }
    func observeOrderBook() {
//        orderBook.observeOrderBook { [weak self] orderBookItems in
//            self?.orderBookItems = orderBookItems.map { OrderBookItemViewModel(orderBookItem: $0) }
//        }
    }
}
