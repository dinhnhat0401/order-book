//
//  OrderBookViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Factory
import Foundation
import Interactors

public protocol OrderBookViewModelProtocol {
    var orderBookItems: [OrderBookItemViewModelProtocol] { get }
}

final class OrderBookViewModel: ObservableObject, OrderBookViewModelProtocol {
    @Published var orderBookItems: [OrderBookItemViewModelProtocol] = []
    @Injected(\.marketDataInteractor) private var marketDataInteractor: MarketDataInteractorProtocol
//    private let orderBook: OrderBookProtocol

    // init() {
    //     self.orderBook = orderBook
    //     self.orderBookItems = orderBook.orderBookItems.map { OrderBookItemViewModel(orderBookItem: $0) }
    // }
    func observeOrderBook() {
//        orderBook.observeOrderBook { [weak self] orderBookItems in
//            self?.orderBookItems = orderBookItems.map { OrderBookItemViewModel(orderBookItem: $0) }
//        }
    }
}
