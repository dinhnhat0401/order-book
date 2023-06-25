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

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                viewModel.fillBackground = false
            }
        }
    }

    var body: some View {
        ZStack {
            if viewModel.fillBackground {
                Rectangle().fill(viewModel.sideColor.opacity(0.4))
            }
            HStack {
                Text(viewModel.price).foregroundColor(viewModel.sideColor).padding(.leading, 10)
                Spacer()
                Text(viewModel.size).foregroundColor(viewModel.sideColor)
                Spacer()
                Text(ViewHelper.convertTimestampToTime(viewModel.timestamp)).foregroundColor(viewModel.sideColor).padding(.trailing, 10)
            }
        }
    }
}
