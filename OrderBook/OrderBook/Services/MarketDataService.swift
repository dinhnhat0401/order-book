//
//  MarketDataService.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

// Create MarketDataService to fetch data from the server via websocket using await/async and websocket

public protocol MarketDataServiceProtocol {
    func connect()
    func disconnect()
    func subscribe(topicArgs: [String]) throws
    func unsubscribe(topicArgs: String)
    func stream() -> AsyncThrowingStream<String, Error>
}

public final class MarketDataService: MarketDataServiceProtocol {
    private let socket: any WebSocketStreamProtocol
	private var isConnected = false

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

//    func subscribe(topicArgs: [String]) throws -> AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator {
    public func subscribe(topicArgs: [String]) throws {
//		guard isConnected else {
//            throw MarketDataServiceError.notConnected
//		}
		// Create json object
        let jsonObject = ["op": "subscribe", "args": topicArgs] as [String : Any]
		// Convert json object to string subscribe to the server
		let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
		let jsonString = String(data: jsonData, encoding: .utf8)! // TODO: not force
		socket.send(jsonString)
//        return socket.makeAsyncIterator()
	}

    public func unsubscribe(topicArgs: String) {
		guard isConnected else {
			return
		}
		socket.send("{\"op\": \"unsubscribe\", \"args\": \(topicArgs)}")
	}

    public func stream() -> AsyncThrowingStream<String, Error> {
		return AsyncThrowingStream { continuation in
            Task {
                // TODO: check this
                continuation.onTermination = { @Sendable [socket] _ in
                    socket.disconnect()
                }

                for try await message in socket {
                    guard case .string(let text) = message else {
                        continue
                    }
                    continuation.yield(text)
                }
            }
		}
	}

	enum MarketDataServiceError: Error {
		case notConnected
	}
}

public protocol WebSocketStreamProtocol: AsyncSequence {
    func connect()
    func disconnect()
	func makeAsyncIterator() -> AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator
	func send(_ message: String)
}

public class WebSocketStream: WebSocketStreamProtocol {

    public typealias Element = URLSessionWebSocketTask.Message
    public typealias AsyncIterator = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator

	private var stream: AsyncThrowingStream<Element, Error>?
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?
    private let socket: URLSessionWebSocketTask

	public init(url: String, session: URLSession = URLSession.shared) {
        socket = session.webSocketTask(with: URL(string: url)!)
        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket.cancel()
            }
        }
    }

    public func connect() {
        socket.resume()
    }

    public func disconnect() {
		socket.cancel()
	}

    public func makeAsyncIterator() -> AsyncIterator {
		guard let stream = stream else {
			fatalError("stream was not initialized")
		}
        // TODO: should it be here?
		listenForMessages()
		return stream.makeAsyncIterator()
	}

    public func send(_ message: String) {
		socket.send(.string(message)) { error in
			if let error = error {
				self.continuation?.finish(throwing: error)
			}
		}
	}

	private func listenForMessages() {
		socket.receive { [unowned self] result in
			switch result {
			case .success(let message):
				continuation?.yield(message)
				listenForMessages()
			case .failure(let error):
				continuation?.finish(throwing: error)
			}
		}
	}
}
