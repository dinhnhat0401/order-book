//
//  MarketDataRepository.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation
import Entities
import Services
import Factory

public protocol MarketDataRepositoryProtocol {
    func connect()
    func disconnect()
    func subscribe(topics: [Topic])
    func unsubscribe(topics: [Topic])
    func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error>
}

public final class MarketDataRepository: MarketDataRepositoryProtocol {
    @Injected(\.marketDataService) private var service: MarketDataServiceProtocol
	private var isConnected = false

    public init() {}

    public func connect() {
		service.connect()
		isConnected = true
	}

    public func disconnect() {
		service.disconnect()
		isConnected = false
	}

    public func subscribe(topics: [Topic]) {
		guard isConnected else {
            // TODO: throw error here
			fatalError("Not connected")
		}
        let topicArgs = topics.map { $0.rawValue }
        // TODO: no force
        try! self.service.subscribe(topicArgs: topicArgs)
	}

    public func unsubscribe(topics: [Topic]) {
		guard isConnected else {
			return
		}
        let topicArgs = topics.map { "\"\($0.rawValue)\"" }.joined(separator: ",")
		service.unsubscribe(topicArgs: topicArgs)
	}

    public func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> {
		return AsyncThrowingStream { continuation in
            Task {
                for try await message in self.service.stream() {
                    if message.contains("delete") {
                        print(message)
                    }
                    // Convert message string to Data
                    guard let data = message.data(using: .utf8) else {
                        continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
                        return
                    }
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let table = (json?["table"] as? String) ?? ""
                    guard table == "orderBookL2" else {
                        // Decode message to Trade
                        guard let decodedTrade = try? JSONDecoder().decode(Trade.self, from: data) else {
                            // TODO: check this
//                            continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
                            continue
                        }
                        // and yield it
                        continuation.yield(decodedTrade as MarketDataResponseProtocol)
                        continue
                    }
                    // Decode message to OrderBookL2
                    guard let decodedOrderBookL2 = try? JSONDecoder().decode(OrderBookL2.self, from: data) else {
//                        continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
                        continue
                    }
                    // and yield it
                    continuation.yield(decodedOrderBookL2 as MarketDataResponseProtocol)
                }
            }
		}
	}
}

extension MarketDataRepository {
	enum MarketDataRepositoryError: Error {
		case notConnected
		case unknown
	}
}
