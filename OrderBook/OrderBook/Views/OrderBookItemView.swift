//
//  OrderBookItemView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI
import ViewModels

public struct OrderBookItemView<ViewModel>: View where ViewModel: OrderBookItemViewModelProtocol {
    @StateObject var viewModel: ViewModel
    var viewWidth: CGFloat

    public var body: some View {
        HStack {
            ZStack {
                HStack(spacing: 0) {
                    HStack {
                        Text(viewModel.buySize).minimumScaleFactor(0.2)
                        Spacer(minLength: 0)
                        Text(viewModel.buyPrice).minimumScaleFactor(0.2)
                            .padding(.trailing, 5.0)
                    }
                    .frame(width: viewWidth / 2.0)
                    HStack {
                        Text(viewModel.sellPrice).minimumScaleFactor(0.2)
                            .padding(.leading, 5.0)
                        Spacer(minLength: 0)
                        Text(viewModel.sellSize).minimumScaleFactor(0.2)
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
							.frame(width: CGFloat(viewWidth / 2.0 * viewModel.buySizePercentage))
                            // .frame(width: CGFloat(viewWidth / 2.0 * SizeHelper.calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedBuyVolume)))
                    }
                    .frame(width: viewWidth / 2.0)
                    HStack {
                        Rectangle()
                            .fill(.red)
							.frame(width: CGFloat(viewWidth / 2.0 * viewModel.sellSizePercentage))
                        Spacer(minLength: 0)
                    }
                    .frame(width: viewWidth / 2.0)
                }.opacity(0.4)
            }
        }
        .frame(width: viewWidth)
    }
}

struct OrderBookItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookItemView(viewModel: OrderBookItemViewModel(orderBookItem: OrderBookItem(buyPrice: "30600", buySize: "0.04", buySizePercentage: 0.13, sellPrice: "31200", sellSize: "0.1", sellSizePercentage: 0.4)), viewWidth: 375.0)
    }
}
