//
//  OrderBookTests.swift
//  OrderBookTests
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import Factory
import XCTest
import SnapshotTesting
import SwiftUI

@testable import OrderBook
@testable import Views
@testable import ViewModels
@testable import Interactors

final class OrderBookTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Container.shared.marketDataInteractor.reset()
    }

    @MainActor
    func testOrderBookSnapshot() async {
        let expectation = XCTestExpectation(description: "test order book snapshot")
        var cancellable = Set<AnyCancellable>()
        Container.shared.marketDataInteractor.register {
            let interactor = MarketDataInteractor()
            interactor.orderBookValueSubject.send([
                OrderBookItem(buyPrice: 100, buySize: 100, buySizePercentage: 0.3, sellPrice: 101, sellSize: 230, sellSizePercentage: 0.4)
            ])
            interactor.orderBookValueSubject.sink { _ in
                expectation.fulfill()
            }.store(in: &cancellable)
            return interactor
        }
        let vm = OrderBookViewModel()
        let orderBook = OrderBookView(viewModel: vm, geoWidth: 375)
        await fulfillment(of: [expectation], timeout: 10)
        let vc = UIHostingController(rootView: orderBook)
        assertSnapshot(matching: vc, as: .image(on: .iPhone13))
        assertSnapshot(matching: vc, as: .image(on: .iPadPro11))
    }
}
