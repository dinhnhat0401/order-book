//
//  Injection+Interactor.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/23.
//

import Factory
import Foundation
import Interactors

extension Container {
    var marketDataInteractor: Factory<MarketDataInteractorProtocol> {
        Factory(self) { MarketDataInteractor() }
    }
}
