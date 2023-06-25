//
//  ServicesTests.swift
//  ServicesTests
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import XCTest
@testable import Services

final class ServicesTests: XCTestCase {
	func testCanFetchDataViaWebsocket() async throws {
        let websocket = WebSocketStream(url: "wss://www.bitmex.com/realtime")
        var cancellable = Set<AnyCancellable>()
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
		let marketDataService = MarketDataService(socket: websocket)
		marketDataService.connect()
		let topicArgs = ["orderBookL2:XBTUSD", "trade:XBTUSD"]
		do {
            try marketDataService.subscribe(topicArgs: topicArgs)
            marketDataService.stream()
            marketDataService.messageStream
                .sink { message in
                    print(message)
                    expectation.fulfill()
                }
                .store(in: &cancellable)
		} catch {
			print(error)
		}
        await fulfillment(of: [expectation], timeout: 10)
	}
}
