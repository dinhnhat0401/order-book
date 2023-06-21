//
//  MarketDataRepository.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation
import Entities
import Services

public protocol MarketDataRepositoryProtocol {
    func connect()
    func disconnect()
    func subscribe(topics: [Topic])
    func unsubscribe(topics: [Topic])
//	func makeAsyncIterator() -> AsyncThrowingStream<any MarketDataResponseProtocol, Error>.Iterator
}

final class MarketDataRepository: MarketDataRepositoryProtocol {
	private let service: MarketDataServiceProtocol
	private var isConnected = false

	init(service: MarketDataServiceProtocol) {
		self.service = service
	}

	func connect() {
		service.connect()
		isConnected = true
	}

	func disconnect() {
		service.disconnect()
		isConnected = false
	}

	func subscribe(topics: [Topic]) {
		guard isConnected else {
            // TODO: throw error here
			fatalError("Not connected")
		}
        let topicArgs = topics.map { $0.rawValue }
        // TODO: no force
        try! self.service.subscribe(topicArgs: topicArgs)

//		// Create AsyncStream<any MarketDataResponseProtocol> from service.subscribe(topicArgs: topicArgs) using continuation
//		return AsyncStream<any MarketDataResponseProtocol> { continuation in
//            // TODO: no force cast
//			_ = try! self.service.subscribe(topicArgs: topicArgs).map { message in
//				// Convert message string to Data
//				guard let message = message as? String, let data = message.data(using: .utf8) else {
////					continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
//					return
//				}
//				let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//				let table = (json?["table"] as? String) ?? ""
//				guard table == "orderBookL2" else {
//					// Decode message to Trade
//					guard let decodedTrade = try? JSONDecoder().decode(Trade.self, from: data) else {
//						// continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
//						return
//					}
//					// and yield it
//					continuation.yield(decodedTrade as MarketDataResponseProtocol)
//					return
//				}
//				// Decode message to OrderBookL2
//				guard let decodedOrderBookL2 = try? JSONDecoder().decode(OrderBookL2.self, from: data) else {
//					// continuation.finish(throwing: MarketDataRepository.MarketDataRepositoryError.unknown)
//					return
//				}
//				// and yield it
//				continuation.yield(decodedOrderBookL2 as MarketDataResponseProtocol)
//			}
//		}
	}

	func unsubscribe(topics: [Topic]) {
		guard isConnected else {
			return
		}
        let topicArgs = topics.map { "\"\($0.rawValue)\"" }.joined(separator: ",")
		service.unsubscribe(topicArgs: topicArgs)
	}

//	func makeAsyncIterator() async -> AsyncThrowingStream<any MarketDataResponseProtocol, Error>.Iterator {
//        for await message in service.makeAsyncIterator() {
//
//        }
//	}
}

extension MarketDataRepository {
	enum MarketDataRepositoryError: Error {
		case notConnected
		case unknown
	}
}
