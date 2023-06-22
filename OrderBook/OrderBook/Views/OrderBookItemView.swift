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

    public init(
		totalSellVolume: Decimal,
		totalBuyVolume: Decimal,
		buyVolume: Decimal,
		accumulatedBuyVolume: Decimal,
		buyPrice: Decimal,
		sellPrice: Decimal,
		sellVolume: Decimal,
		accumulatedSellVolume: Decimal) {
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
		GeometryReader { geo in
			HStack {
				ZStack {
                    HStack {
                        HStack {
                            Text("\(DecimalHelper.format(buyVolume, precision: 2))").minimumScaleFactor(0.2)
                            Spacer()
                            Text("\(DecimalHelper.format(buyPrice, precision: 2))").minimumScaleFactor(0.2)
                        }
                        HStack {
                            Text("\(DecimalHelper.format(sellPrice, precision: 2))").minimumScaleFactor(0.2)
                            Spacer()
                            Text("\(DecimalHelper.format(sellVolume, precision: 2))").minimumScaleFactor(0.2)
                        }
                    }

					// Display a rectangular shape with a gradient color green
					// The width of the rectangle is calculated based on the totalBuyVolume and buyVolume
					// The height of the rectangle is 50
					// The rectangle is displayed on the left of the text
					// color alpha is 0.4
                    HStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(Gradient(colors: [Color.green]))
                                .frame(width: CGFloat(geo.size.width / 2.0 * SizeHelper.calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedBuyVolume)), height: 50, alignment: .leading)
                        }
                        HStack {
                            Rectangle()
                                .fill(Gradient(colors: [Color.red]))
                                .frame(width: CGFloat(geo.size.width / 2.0 * SizeHelper.calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedSellVolume)), height: 50, alignment: .leading)
                            Spacer()
                        }
                    }.opacity(0.4)
				}
			}
			.padding(.horizontal, 20)
			.frame(width: geo.size.width, height: 50, alignment: .center)
		}
    }
}

struct OrderBookItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookItemView(totalSellVolume: Decimal(100000), totalBuyVolume: Decimal(60000), buyVolume: Decimal(4000), accumulatedBuyVolume: Decimal(20200), buyPrice: Decimal(10), sellPrice: Decimal(11), sellVolume: Decimal(12090), accumulatedSellVolume: Decimal(80000))
    }
}
