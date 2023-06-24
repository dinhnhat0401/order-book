//
//  TradeScreen.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI
import ViewModels

public struct TradeScreen<ViewModel>: View where ViewModel: TradeScreenViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @State private var selectedTab: Int = 0

    let tabs: [Tab] = [
        .init(title: "Order Book"),
        .init(title: "Recent Trades"),
    ]

	public init(viewModel: ViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}

    public var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
               	Text("XBTUSD")
               	// Tabs
               	Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)

               	// Views
               	TabView(selection: $selectedTab,
                    content: {
                    OrderBookView(viewModel: viewModel.orderBookViewModel as? OrderBookViewModel ?? OrderBookViewModel(), geoWidth: geo.size.width).tag(0)
                    RecentTradeView(viewModel: viewModel.recentTradeViewModel as? RecentTradeViewModel ?? RecentTradeViewModel()).tag(1)
               		})
               .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
           }
           .navigationBarTitleDisplayMode(.inline)
       }
   }
}

struct TradeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TradeScreen(viewModel: TradeScreenViewModel())
    }
}
