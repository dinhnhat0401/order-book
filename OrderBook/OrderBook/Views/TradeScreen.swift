//
//  TradeScreen.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI

public struct TradeScreen: View {
    @State private var selectedTab: Int = 0

    let tabs: [Tab] = [
        .init(title: "Order Book"),
        .init(title: "Recent Trades"),
    ]

    public init() {
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
                        OrderBookView().tag(0)
                		RecentTradeView().tag(1)
               		})
               .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
           }
           .navigationBarTitleDisplayMode(.inline)
       }
   }
}

struct TradeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TradeScreen()
    }
}
