//
//  MarketDataService.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import Foundation

// Create MarketDataService to fetch data from the server via websocket using await/async and websocket

public protocol MarketDataServiceProtocol {
    var messageStream: CurrentValueSubject<String, Never> { get }

    func connect()
    func disconnect()
    func subscribe(topicArgs: [String]) throws
    func unsubscribe(topicArgs: String) throws
   	func stream()
}

public final class MarketDataService: MarketDataServiceProtocol {
    public var messageStream = CurrentValueSubject<String, Never>("")
    private let socket: any WebSocketStreamProtocol
	private var isConnected = false
    private var streamingData = false

    public init(socket: any WebSocketStreamProtocol) {
		self.socket = socket
	}

    public func connect() {
		socket.connect()
		isConnected = true
	}

    public func disconnect() {
		socket.disconnect()
		isConnected = false
	}

    public func subscribe(topicArgs: [String]) throws {
		guard isConnected else {
           throw MarketDataServiceError.notConnected
		}
        let jsonObject = ["op": "subscribe", "args": topicArgs] as [String : Any]
		// Convert json object to string subscribe to the server
		let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
		guard let jsonString = String(data: jsonData, encoding: .utf8) else {
			throw MarketDataServiceError.cannotEncodeString
		}
		socket.send(jsonString)
	}

    public func unsubscribe(topicArgs: String) throws {
		guard isConnected else {
			throw MarketDataServiceError.notConnected
		}
		socket.send("{\"op\": \"unsubscribe\", \"args\": \(topicArgs)}")
	}

    public func stream() {
        guard !streamingData else {
            return
        }
        streamingData = true
        Task {
            for try await message in socket {
                guard case .string(let text) = message else {
                    continue
                }
                messageStream.send(text)
            }
        }
	}
}

extension MarketDataService {
	public enum MarketDataServiceError: LocalizedError {
		case notConnected
		case cannotEncodeString

		public var errorDescription: String? {
			switch self {
			case .notConnected:
				return "Not connected"
			case .cannotEncodeString:
				return "Cannot encode string"
			}
		}

		public var failureReason: String? {
			switch self {
			case .notConnected:
				return "Not connected"
			case .cannotEncodeString:
				return "Cannot encode string"
			}
		}
	}
}
