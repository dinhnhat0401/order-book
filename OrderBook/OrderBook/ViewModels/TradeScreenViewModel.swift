//
//  TradeScreenViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation

public protocol TradeScreenViewModelProtocol: ObservableObject {
    var orderBookViewModel: OrderBookViewModel { get }
}

public class TradeScreenViewModel: TradeScreenViewModelProtocol {
    public var orderBookViewModel: OrderBookViewModel

    public init(orderBookViewModel: OrderBookViewModel) {
        self.orderBookViewModel = orderBookViewModel
    }
}
