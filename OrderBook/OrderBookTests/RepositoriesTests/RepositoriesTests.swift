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

    func testCanDecodeMarketData() {
        let marketDataRepository = MarketDataRepository()
        let orderBookL2Data = """
        {"table":"orderBookL2","action":"update","data":[{"symbol":"XBTUSD","id":8799999000,"side":"Sell","size":1000,"price":0.1, "timestamp": "2023-06-19T12:39:31.054Z"}]}
        """.data(using: .utf8)!
        let decodedData = marketDataRepository.decodeMarketData(data: orderBookL2Data) as! OrderBookL2
        XCTAssertEqual(decodedData.table, "orderBookL2")
        XCTAssertEqual(decodedData.action, .update)
        XCTAssertEqual(decodedData.data.count, 1)
        XCTAssertEqual(decodedData.data[0].symbol, "XBTUSD")
        XCTAssertEqual(decodedData.data[0].id, 8799999000)
        XCTAssertEqual(decodedData.data[0].side, .sell)
        XCTAssertEqual(decodedData.data[0].size, 1000)
        XCTAssertEqual(decodedData.data[0].price, 0.1)

        let tradeData = """
        {"table":"trade","action":"insert","data":[{"timestamp":"2021-06-19T08:00:00.000Z","symbol":"XBTUSD","side":"Buy","size":1000,"price":0.1,"tickDirection":"ZeroPlusTick","trdMatchID":"00000000-0000-0000-0000-000000000000","grossValue":100000,"homeNotional":0.001,"foreignNotional":0.1}]}
        """.data(using: .utf8)!
        let decodedTradeData = marketDataRepository.decodeMarketData(data: tradeData) as! Trade
        XCTAssertEqual(decodedTradeData.table, "trade")
        XCTAssertEqual(decodedTradeData.action, .insert)
        XCTAssertEqual(decodedTradeData.data.count, 1)
        XCTAssertEqual(decodedTradeData.data[0].timestamp, "2021-06-19T08:00:00.000Z")
        XCTAssertEqual(decodedTradeData.data[0].symbol, "XBTUSD")
        XCTAssertEqual(decodedTradeData.data[0].side, .buy)
        XCTAssertEqual(decodedTradeData.data[0].size, 1000)
        XCTAssertEqual(decodedTradeData.data[0].price, 0.1)
    }
}
