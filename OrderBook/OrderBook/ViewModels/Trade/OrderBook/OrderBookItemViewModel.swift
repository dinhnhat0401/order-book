//
//  OrderBookItemViewModel.swift
//  ViewModels
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI
import Interactors

public protocol OrderBookItemViewModelProtocol: ObservableObject, Identifiable {
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

public final class OrderBookItemViewModel: ObservableObject, OrderBookItemViewModelProtocol {
    @Published public var buyPrice: String = ""
    @Published public var buyPriceColor: Color = .green
    @Published public var buySize: String = ""
    @Published public var buySizePercentage: Double = 0
    @Published public var buySizeColor: Color = .green

    @Published public var sellPrice: String = ""
    @Published public var sellPriceColor: Color = .red
    @Published public var sellSize: String = ""
    @Published public var sellSizePercentage: Double = 0
    @Published public var sellSizeColor: Color = .red

	public init(buyPrice: String, buySize: String, buySizePercentage: Double, sellPrice: String, sellSize: String, sellSizePercentage: Double) {
		self.buyPrice = buyPrice
		self.buySize = buySize
		self.buySizePercentage = buySizePercentage
		self.sellPrice = sellPrice
		self.sellSize = sellSize
		self.sellSizePercentage = sellSizePercentage
	}
}
