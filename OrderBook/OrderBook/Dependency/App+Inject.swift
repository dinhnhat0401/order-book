//
//  App+Inject.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/23.
//

import Foundation
import Factory
import Repositories
import Interactors
import Services

//extension Container {
//    // Services
//    var marketDataService: Factory<MarketDataServiceProtocol> {
//        self { MarketDataService(socket: WebSocketStream(url: "wss://ws.bitmex.com/realtime")) } // TODO: make this constant
//            .scope(.shared)
//    }
//
//    // Repositories
//    var marketDataRepository: Factory<MarketDataRepositoryProtocol> {
//        Factory(self) { MarketDataRepository() }
//    }
//
//    // Interactors
//    var marketDataInteractor: Factory<MarketDataInteractorProtocol> {
//        Factory(self) { MarketDataInteractor() }
//    }
//}
