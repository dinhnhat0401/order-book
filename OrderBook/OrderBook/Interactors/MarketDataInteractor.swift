//
//  MarketDataInteractor.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation
import Entities
import Repositories

public protocol MarketDataInteractorProtocol {
    func connect()
    func disconnect()
//    func subscribe(topics: [Topic]) -> AsyncStream<any MarketDataResponseProtocol>
    func unsubscribe(topics: [Topic])
}

final class MarketDataInteractor: MarketDataInteractorProtocol {
	private let repository: MarketDataRepositoryProtocol

	init(repository: MarketDataRepositoryProtocol) {
		self.repository = repository
	}

	func connect() {
		repository.connect()
	}

	func disconnect() {
		repository.disconnect()
	}

//	func subscribe(topics: [Topic]) -> AsyncStream<any MarketDataResponseProtocol> {
////		repository.subscribe(topics: topics)
//	}

	func unsubscribe(topics: [Topic]) {
		repository.unsubscribe(topics: topics)
	}
}
