//
//  OrderBookView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI
import ViewModels

// Subscribe topic to receive order-book data via web-socket from BitMEX.
// size in BitMEX and qty in AQX are equal concept.
// Make whole scroll scrollable except top section tab control.
// If content rows are not enough to fill the screen, increase row height. Place 20 “buy” items sorted in descending order at left.
// Place 20 “sell” items sorted in ascending order at right.
// Draw relative volume of accumulated size s in the background of each rows.

struct OrderBookView<ViewModel>: View where ViewModel: OrderBookViewModelProtocol {
    @StateObject var viewModel: ViewModel
    var geoWidth: CGFloat

	var body: some View {
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
//                    .frame(width: geoWidth, height: 50, alignment: .center)
            }

            // Scrollable view
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.orderBookItemViewModels) { item in
						OrderBookItemView(viewModel: item, viewWidth: geoWidth)
					}
                }
            }
        }
        .if(viewModel.loading) { view in
            view.overlay(
                VStack {
                    ProgressView()
                }
            )
        }
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView(viewModel: OrderBookViewModel(), geoWidth: 400)
    }
}
