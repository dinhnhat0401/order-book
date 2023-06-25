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
    @MainActor
	func testCanFetchDataViaWebsocket() async throws {
        let websocket = WebSocketStream(url: "wss://www.bitmex.com/realtime")
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
		let marketDataService = MarketDataService(socket: websocket)
		marketDataService.connect()
		let topicArgs = ["orderBookL2:XBTUSD", "trade:XBTUSD"]
		do {
            // subscribe to asyncstream
			// await for the first message
            try marketDataService.subscribe(topicArgs: topicArgs)
//            for try await message in marketDataService.stream() {
//                print(message)
//                expectation.fulfill()
//            }

		} catch {
			print(error)
		}
        await fulfillment(of: [expectation], timeout: 10)
	}
}
