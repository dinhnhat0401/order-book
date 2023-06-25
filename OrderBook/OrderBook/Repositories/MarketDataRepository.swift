//
//  MarketDataRepository.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import Foundation
import Entities
import Services
import Factory

public protocol MarketDataRepositoryProtocol {
    func connect()
    func disconnect()
    func subscribe(topics: [Topic]) throws
    func unsubscribe(topics: [Topic]) throws
//    var marketDataStream: CurrentValueSubject<MarketDataResponseProtocol?, MarketDataRepository.MarketDataRepositoryError> { get }
    func stream() -> AnyPublisher<MarketDataResponseProtocol, Never>
}

public final class MarketDataRepository: MarketDataRepositoryProtocol {
    public var marketDataStream = CurrentValueSubject<MarketDataResponseProtocol?, MarketDataRepositoryError>(nil)
    @Injected(\.marketDataService) private var service: MarketDataServiceProtocol
    private var cancellable = Set<AnyCancellable>()

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

    public func stream() -> AnyPublisher<MarketDataResponseProtocol, Never> {
        service.stream()
		// Convert data from currentValue subject to AnyPublisher
		return self.service.messageStream
			.compactMap { [weak self] message in
				guard let self = self else {
					return nil
				}
				// Convert message string to Data
				guard let data = message.data(using: .utf8) else {
					return nil
				}
				guard let decodedData = self.decodeMarketData(data: data) else {
					return nil
				}
				return decodedData
			}
			.eraseToAnyPublisher()
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
	public enum MarketDataRepositoryError: LocalizedError {
		case notConnected
        case invalidMessageData
		case unknown

		public var errorDescription: String? {
			switch self {
			case .notConnected:
				return "Not connected to the server"
			case .invalidMessageData:
				return "Invalid message data"
			case .unknown:
				return "Unknown error"
			}
		}

		public var failureReason: String? {
			switch self {
			case .notConnected:
				return "Not connected to the server"
			case .invalidMessageData:
				return "Invalid message data"
			case .unknown:
				return "Unknown error"
			}
		}
	}
}
