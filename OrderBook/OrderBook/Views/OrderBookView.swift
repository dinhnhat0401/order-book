//
//  OrderBookView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI

// Subscribe topic to receive order-book data via web-socket from BitMEX.
// size in BitMEX and qty in AQX are equal concept.
// Make whole scroll scrollable except top section tab control.
// If content rows are not enough to fill the screen, increase row height. Place 20 “buy” items sorted in descending order at left.
// Place 20 “sell” items sorted in ascending order at right.
// Draw relative volume of accumulated size s in the background of each rows.

struct OrderBookView: View {
	var sell: [Decimal] = [
		100,
		200,
		300,
		400,
		500,
		600,
		700,
		800,
		900,
		1000,
		1100,
		1200,
		1300,
		1400,
		1500,
		1600,
		1700,
		1800,
		1900,
		2000,
	]

	var buy: [Decimal] = [
		100,
		200,
		300,
		400,
		500,
		600,
		700,
		800,
		900,
		1000,
		1100,
		1200,
		1300,
		1400,
		1500,
		1600,
		1700,
		1800,
		1900,
		2000,
	]

	var body: some View {
		GeometryReader { geo in
			// Header view with Qty, Price(USD), Qty labels
			// Scrollable view with 20 buy items and 20 sell items

			// Header view
            VStack {
                VStack {
                    HStack {
                        Text("Qty").foregroundColor(.secondary)
                        Spacer()
                        Text("Price(USD)").foregroundColor(.secondary)
                        Spacer()
                        Text("Qty").foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .frame(width: geo.size.width, height: 50, alignment: .center)
                }

                // Scrollable view
                ScrollView {
                    VStack {
                        ForEach(0..<sell.count) { i in
                            OrderBookItemView(
								totalSellVolume: sell.reduce(0, +),
								totalBuyVolume: buy.reduce(0, +),
								buyVolume: buy[i],
								accumulatedBuyVolume: buy[0..<i].reduce(0, +),
								buyPrice: 1000,
								sellPrice: 1000,
								sellVolume: sell[i],
								accumulatedSellVolume: sell[0..<i].reduce(0, +)
							)
                        }
                    }
                }
            }
		}
	}
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView()
    }
}
