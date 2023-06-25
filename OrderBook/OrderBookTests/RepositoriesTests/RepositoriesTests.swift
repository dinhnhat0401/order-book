//
//  RepositoriesTests.swift
//  RepositoriesTests
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import XCTest
import Entities
@testable import Services
@testable import Repositories

final class RepositoriesTests: XCTestCase {
    func testCanParseDataGotFromService() async {
		let expectation = XCTestExpectation(description: "Fetch data via websocket")
        expectation.expectedFulfillmentCount = 10
        var cancellable = Set<AnyCancellable>()
		let marketDataRepository = MarketDataRepository()
        marketDataRepository.connect()
        try! marketDataRepository.subscribe(topics: [.orderBook(symbol: "XBTUSD"), .trades(symbol: "XBTUSD")])
        marketDataRepository.stream()
            .sink { data in
                print(data)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        await fulfillment(of: [expectation], timeout: 100)
    }
}
