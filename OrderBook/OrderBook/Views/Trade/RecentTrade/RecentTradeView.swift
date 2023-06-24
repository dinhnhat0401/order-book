//
//  RecentTradeView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI
import ViewModels

// Subscribe trade:XBTUSD topic to receive recent-trade data vis web-socket from BitMEX. Show 30 latest trades. Sorted in descending order of time. (timestamp)
// Trade is “insert”-only. No need to keep whole dataset in memory as we need only last 30 trades. Trade data before the time of switching to “Recent Trade” tab.
// If there’s less than 30 data after the tap switch, it’s fine to show them only. Render “buy” trade in green, “sell” trade in red.
// Fill backgrounds of newly added items with lighter green/red colors for 0.2 seconds.
// Remove the filling after 0.2 seconds.

public struct RecentTradeView<ViewModel>: View where ViewModel: RecentTradeViewModel {
    @StateObject var viewModel: ViewModel

    public var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Price(USD)").foregroundColor(.secondary)
                    Spacer()
                    Text("Qty").foregroundColor(.secondary)
                    Spacer()
                    Text("Time").foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
            }

            // Scrollable view
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.recentTradeViewModels) { item in
                        TradeItemView(viewModel: item)
                    }
                }
            }
        }.if(viewModel.loading) { view in
            view.overlay(
                VStack {
                    ProgressView()
                }
            )
        }
    }
}
