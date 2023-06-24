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
        ZStack {
            if viewModel.fillBackground {
                Rectangle().fill(viewModel.sideColor.opacity(0.4))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                viewModel.fillBackground = false
                            }
                        }
                    }
            }
            HStack {
                Text(viewModel.price).foregroundColor(viewModel.sideColor)
                Spacer()
                Text(viewModel.size).foregroundColor(viewModel.sideColor)
                Spacer()
                Text(ViewHelper.convertTimestampToTime(viewModel.timestamp)).foregroundColor(viewModel.sideColor)
            }
        }
    }
}
