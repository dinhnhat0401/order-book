//
//  InteractorsTests.swift
//  InteractorsTests
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import XCTest
@testable import Interactors
@testable import Repositories
@testable import Services
@testable import Entities

final class InteractorsTests: XCTestCase {
    func testCanGetDataViaRepository() async {
        var cancellable = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Fetch data via websocket")
        let marketDataInteractor = MarketDataInteractor()
        marketDataInteractor.connect()
        try! marketDataInteractor.subscribe(topics: ["trade:XBTUSD", "orderBookL2:XBTUSD"])
        marketDataInteractor.streamData()
        marketDataInteractor.orderBookValueSubject
            .dropFirst()
            .sink { data in
                print(data)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        await fulfillment(of: [expectation], timeout: 10)
    }

    func testCanGenerateOrderBookItem() {
        let sut = MarketDataInteractor()
        let orderBookData: [Side: [Decimal: [OrderBookL2Data]]] = [
            .sell: [
                0.1: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.1, timestamp: "2023-06-19T12:39:31.054Z")],
                0.2: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.2, timestamp: "2023-06-19T12:39:31.054Z")],
                0.3: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.3, timestamp: "2023-06-19T12:39:31.054Z")],
                0.4: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.4, timestamp: "2023-06-19T12:39:31.054Z")],
                0.5: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.5, timestamp: "2023-06-19T12:39:31.054Z")],
                0.6: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.6, timestamp: "2023-06-19T12:39:31.054Z")],
                0.7: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.7, timestamp: "2023-06-19T12:39:31.054Z")],
                0.8: [OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.8, timestamp: "2023-06-19T12:41:31.054Z")],
            ]
        ]
        let orderBookItem = sut.generateOrderBookItem(orderBookData)
        XCTAssertEqual(orderBookItem.count, 8)
    }

    func testHandleTradeData() {
        let sut = MarketDataInteractor()
        var cancellable = Set<AnyCancellable>()
        let tradeData: Trade = Trade(table: "", action: .insert, data: [
            TradeData(timestamp: "2021-06-19T08:00:00.000Z", symbol: "XBTUSD", side: .buy, size: 1000, price: 0.1),
            TradeData(timestamp: "2021-06-19T08:00:00.000Z", symbol: "XBTUSD", side: .buy, size: 1000, price: 0.1),
            TradeData(timestamp: "2021-06-19T08:00:00.000Z", symbol: "XBTUSD", side: .buy, size: 1000, price: 0.1),
            TradeData(timestamp: "2021-06-19T08:00:00.000Z", symbol: "XBTUSD", side: .buy, size: 1000, price: 0.1)
        ])
        sut.handleTradeData(trade: tradeData)
        sut.tradeValueSubject
            .sink { tradeData in
                XCTAssertEqual(tradeData.count, 4)
            }
            .store(in: &cancellable)
    }

    func testHandleOrderBookData() {
        let sut = MarketDataInteractor()
        var cancellable = Set<AnyCancellable>()
        let orderBookData: OrderBookL2 = OrderBookL2(table: "", action: .update, data: [
            OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.1, timestamp: "2023-06-19T12:39:31.054Z"),
            OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.2, timestamp: "2023-06-19T12:39:31.054Z"),
            OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.3, timestamp: "2023-06-19T12:39:31.054Z"),
            OrderBookL2Data(symbol: "XBTUSD", id: 8799999000, side: .sell, size: 1000, price: 0.4, timestamp: "2023-06-19T12:39:31.054Z")
        ])
        sut.handleOrderBookData(orderBookL2: orderBookData)
        sut.orderBookValueSubject
            .sink { orderBookData in
                XCTAssertEqual(orderBookData.count, 4)
            }
            .store(in: &cancellable)
    }
}
