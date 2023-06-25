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
    let websocket = WebSocketStream(url: "wss://www.bitmex.com/realtime")
    var sut: MarketDataService!

	func testCanFetchDataViaWebsocket() async throws {
        sut = MarketDataService(socket: websocket)
        var cancellable = Set<AnyCancellable>()
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
		sut.connect()
		let topicArgs = ["orderBookL2:XBTUSD", "trade:XBTUSD"]
		do {
            try sut.subscribe(topicArgs: topicArgs)
            sut.stream()
            sut.messageStream
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

    func testCanConvertToJsonString() {
        sut = MarketDataService(socket: websocket)
        let jsonObject = ["op": "subscribe", "args": ["orderBookL2:XBTUSD", "trade:XBTUSD"]] as [String : Any]
        let jsonString = try! sut.convertToJsonString(jsonObject: jsonObject)
        XCTAssertTrue(
            ["{\"op\":\"subscribe\",\"args\":[\"orderBookL2:XBTUSD\",\"trade:XBTUSD\"]}",
             "{\"args\":[\"orderBookL2:XBTUSD\",\"trade:XBTUSD\"],\"op\":\"subscribe\"}"].contains(jsonString))
    }
}
