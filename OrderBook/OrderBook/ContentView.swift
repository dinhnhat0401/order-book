//
//  ContentView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import SwiftUI
import Views
import ViewModels

struct ContentView: View {
    var body: some View {
        TradeScreen(viewModel: TradeScreenViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
