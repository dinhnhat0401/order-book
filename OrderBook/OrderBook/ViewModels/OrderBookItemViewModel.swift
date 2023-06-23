//
//  OrderBookItemViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI

public protocol OrderBookItemViewModelProtocol {
    var buyPrice: String { get }
    var buyPriceColor: Color { get }
    var buySize: String { get }
    var buySizePercentage: Double { get }
    var buySizeColor: Color { get }

    var sellPrice: String { get }
    var sellPriceColor: Color { get }
    var sellSize: String { get }
    var sellSizePercentage: Double { get }
    var sellSizeColor: Color { get }
}
