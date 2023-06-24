//
//  Injection+Repo.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/23.
//

import Foundation
import Factory
import Repositories

extension Container {
    // Repositories
    var marketDataRepository: Factory<MarketDataRepositoryProtocol> {
        Factory(self) { MarketDataRepository() }.scope(.singleton)
    }
}
