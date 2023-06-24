//
//  Injection+Service.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/23.
//

import Foundation
import Factory
import Services

extension Container {
    // Repositories
    var marketDataService: Factory<MarketDataServiceProtocol> {
        self { MarketDataService(socket: WebSocketStream(url: "wss://ws.bitmex.com/realtime")) }
            .scope(.shared)
    }
}
