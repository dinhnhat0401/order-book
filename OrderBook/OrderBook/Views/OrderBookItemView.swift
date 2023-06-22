//
//  OrderBookItemView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI

public struct OrderBookItemView: View {
	var totalSellVolume: Decimal
	var totalBuyVolume: Decimal
	var buyVolume: Decimal
	var accumulatedBuyVolume: Decimal
	var buyPrice: Decimal
	var sellPrice: Decimal
	var sellVolume: Decimal
	var accumulatedSellVolume: Decimal
    var viewWidth: CGFloat

    public init(
        viewWidth: CGFloat,
		totalSellVolume: Decimal,
		totalBuyVolume: Decimal,
		buyVolume: Decimal,
		accumulatedBuyVolume: Decimal,
		buyPrice: Decimal,
		sellPrice: Decimal,
		sellVolume: Decimal,
		accumulatedSellVolume: Decimal) {
            self.viewWidth = viewWidth
		self.totalBuyVolume = totalBuyVolume
		self.totalSellVolume = totalSellVolume
		self.buyVolume = buyVolume
		self.accumulatedBuyVolume = accumulatedBuyVolume
		self.sellVolume = sellVolume
		self.buyPrice = buyPrice
		self.sellPrice = sellPrice
		self.accumulatedSellVolume = accumulatedSellVolume
    }

    public var body: some View {
        HStack {
            ZStack {
                HStack(spacing: 0) {
                    HStack {
                        Text("\(DecimalHelper.format(buyVolume, precision: 2))").minimumScaleFactor(0.2)
                        Spacer(minLength: 0)
                        Text("\(DecimalHelper.format(buyPrice, precision: 2))").minimumScaleFactor(0.2)
                            .padding(.trailing, 5.0)
                    }
                    .frame(width: viewWidth / 2.0)
                    HStack {
                        Text("\(DecimalHelper.format(sellPrice, precision: 2))").minimumScaleFactor(0.2)
                            .padding(.leading, 5.0)
                        Spacer(minLength: 0)
                        Text("\(DecimalHelper.format(sellVolume, precision: 2))").minimumScaleFactor(0.2)
                    }
                    .frame(width: viewWidth / 2.0)
                }

                // Display a rectangular shape with a gradient color green
                // The width of the rectangle is calculated based on the totalBuyVolume and buyVolume
                // The height of the rectangle is 50
                // The rectangle is displayed on the left of the text
                // color alpha is 0.4
                HStack(spacing: 0) {
                    HStack {
                        Spacer(minLength: 0)
                        Rectangle()
                            .fill(.green)
                            .frame(width: CGFloat(viewWidth / 2.0 * SizeHelper.calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedBuyVolume)))
                    }
                    .frame(width: viewWidth / 2.0)
                    HStack {
                        Rectangle()
                            .fill(.red)
                            .frame(width: CGFloat(viewWidth / 2.0 * SizeHelper.calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedSellVolume)))
                        Spacer(minLength: 0)
                    }
                    .frame(width: viewWidth / 2.0)
                }.opacity(0.4)
            }
        }
//        .padding(.horizontal, 20)
        .frame(width: viewWidth)
    }
}

struct OrderBookItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookItemView(viewWidth: 375, totalSellVolume: Decimal(100000), totalBuyVolume: Decimal(60000), buyVolume: Decimal(4000), accumulatedBuyVolume: Decimal(20200), buyPrice: Decimal(10), sellPrice: Decimal(11), sellVolume: Decimal(12090), accumulatedSellVolume: Decimal(100000))
    }
}
