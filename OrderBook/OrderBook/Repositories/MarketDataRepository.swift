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
    func subscribe(topics: [Topic]) throws
    func unsubscribe(topics: [Topic]) throws
    func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error>
}

public final class MarketDataRepository: MarketDataRepositoryProtocol {
    @Injected(\.marketDataService) private var service: MarketDataServiceProtocol

    public init() {}

    public func connect() {
		service.connect()
	}

    public func disconnect() {
		service.disconnect()
	}

    public func subscribe(topics: [Topic]) throws {
        let topicArgs = topics.map { $0.rawValue }
        try self.service.subscribe(topicArgs: topicArgs)
	}

    public func unsubscribe(topics: [Topic]) throws {
        let topicArgs = topics.map { "\"\($0.rawValue)\"" }.joined(separator: ",")
		try service.unsubscribe(topicArgs: topicArgs)
	}

    public func stream() -> AsyncThrowingStream<MarketDataResponseProtocol, Error> {
		return AsyncThrowingStream { continuation in
            Task {
                for try await message in self.service.stream() {
                    // Convert message string to Data
                    guard let data = message.data(using: .utf8) else {
                        continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
                        return
                    }
                    guard let decodedData = decodeMarketData(data: data) else {
                        continue
                    }
                    continuation.yield(decodedData)
                }
            }
		}
	}

    func decodeMarketData(data: Data) -> MarketDataResponseProtocol? {
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let table = (json?["table"] as? String) ?? ""
        guard table == "orderBookL2" else {
            // Decode message to Trade
            guard let decodedTrade = try? JSONDecoder().decode(Trade.self, from: data) else {
                return nil
            }
            return decodedTrade
        }
        // Decode message to OrderBookL2
        guard let decodedOrderBookL2 = try? JSONDecoder().decode(OrderBookL2.self, from: data) else {
            return nil
        }
        return decodedOrderBookL2
    }
}

extension MarketDataRepository {
	enum MarketDataRepositoryError: Error {
		case notConnected
		case unknown
	}
}
