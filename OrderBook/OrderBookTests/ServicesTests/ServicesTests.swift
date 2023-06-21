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
//		let webSocketURL = URL(string: "wss://www.bitmex.com/realtime")!
        let websocket = WebSocketStream(url: "wss://www.bitmex.com/realtime")
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
		let marketDataService = MarketDataService(socket: websocket)
		marketDataService.connect()
        try! await Task.sleep(nanoseconds: 1_000_000_000)
		let topicArgs = ["orderBookL2:XBTUSD", "trade:XBTUSD"]
		do {
            // subscribe to asyncstream
			// await for the first message
            try marketDataService.subscribe(topicArgs: topicArgs)

//            Task {  in
            for try await message in marketDataService.stream() {
                    print(message)
                    //				expectation.fulfill()
                }
//            }
//            try marketDataService.subscribe(topicArgs: topicArgs)

		} catch {
			print(error)
		}
//        await fulfillment(of: [expectation])
       XCTWaiter.wait(for: [expectation], timeout: 100)
	}
}
