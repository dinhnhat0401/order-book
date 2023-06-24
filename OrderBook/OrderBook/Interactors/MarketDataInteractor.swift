//
//  MarketDataInteractor.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation
import Entities
import Repositories
import Factory

public protocol MarketDataInteractorProtocol {
    func connect()
    func disconnect()
    func unsubscribe(topics: [Topic])
	func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> // TODO: rename this?
}

public final class MarketDataInteractor: MarketDataInteractorProtocol {
    @Injected(\.marketDataRepository) var repository: MarketDataRepositoryProtocol
    private var sellSide: [OrderBookL2Data]
    private var buySide: [OrderBookL2Data]

	public init() {
        sellSide = []
        buySide = []
	}

	public func connect() {
		repository.connect()
	}

    public func disconnect() {
		repository.disconnect()
	}

    public func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> {
        return repository.stream()
	}

    public func unsubscribe(topics: [Topic]) {
		repository.unsubscribe(topics: topics)
	}
}
