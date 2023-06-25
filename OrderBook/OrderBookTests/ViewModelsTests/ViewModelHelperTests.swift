//
//  ViewModelHelperTests.swift
//  OrderBookTests
//
//  Created by Đinh Văn Nhật on 2023/06/25.
//

import Foundation
import XCTest
@testable import ViewModels

class ViewModelHelperTests: XCTestCase {
    func testFormatDecimal() {
        XCTAssertEqual(ViewModelHelper.format(Decimal(1.23456789)), "1.2")
        XCTAssertEqual(ViewModelHelper.format(Decimal(0.003)), "0.003")
    }

    func testCalculateNumberOfDigits() {
        XCTAssertEqual(ViewModelHelper.caclulateNumberOfDigits(Decimal(1.23456789)), 0)
        XCTAssertEqual(ViewModelHelper.caclulateNumberOfDigits(Decimal(0.003)), 3)
        XCTAssertEqual(ViewModelHelper.caclulateNumberOfDigits(Decimal(0.000004)), 6)
        XCTAssertEqual(ViewModelHelper.caclulateNumberOfDigits(Decimal(40383)), 0)
        XCTAssertEqual(ViewModelHelper.caclulateNumberOfDigits(Decimal(10)), 0)
    }
}
