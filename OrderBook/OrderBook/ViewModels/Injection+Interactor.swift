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
    static var mk = MarketDataInteractor()
    var marketDataInteractor: Factory<MarketDataInteractorProtocol> {
//        Factory(self) { MarketDataInteractor() }
        Factory(self) { Container.mk }
    }
}
