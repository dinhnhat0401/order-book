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
import Entities

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
}
