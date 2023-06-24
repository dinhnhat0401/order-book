//
//  RecentTradeItemView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation
import ViewModels
import SwiftUI

struct TradeItemView<ViewModel>: View where ViewModel: TradeItemViewModelProtocol {
    @StateObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text(viewModel.price).foregroundColor(viewModel.sideColor)
            Spacer()
            Text(viewModel.size).foregroundColor(viewModel.sideColor)
            Spacer()
            Text(viewModel.timestamp).foregroundColor(viewModel.sideColor)
        }
    }
}
