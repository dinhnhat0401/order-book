//
//  WebSocketStream.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation

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
