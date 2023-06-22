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
    func unsubscribe(topics: [Topic])
	func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> // TODO: rename this?
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

	func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> {
		return repository.stream()
	}

	func unsubscribe(topics: [Topic]) {
		repository.unsubscribe(topics: topics)
	}
}
