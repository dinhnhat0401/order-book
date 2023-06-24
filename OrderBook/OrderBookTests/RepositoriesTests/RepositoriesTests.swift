//
//  RepositoriesTests.swift
//  RepositoriesTests
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import XCTest
import Entities
@testable import Services
@testable import Repositories

final class RepositoriesTests: XCTestCase {
    func testCanParseDataGotFromService() async {
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
		let marketDataRepository = MarketDataRepository()
        marketDataRepository.connect()
        try! marketDataRepository.subscribe(topics: [.orderBook(symbol: "XBTUSD"), .trades(symbol: "XBTUSD")])
		do {
            for try await message in marketDataRepository.stream() {
                print(message)
            }

		} catch {
			print(error)
		}
        await fulfillment(of: [expectation], timeout: 100)
    }
}
