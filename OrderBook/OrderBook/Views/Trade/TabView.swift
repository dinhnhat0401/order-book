//
//  TabView.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/22.
//

import Foundation
import SwiftUI

struct Tab {
    var title: String
}

struct Tabs: View {
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        // Text
                                        Text(tabs[row].title)
                                            .font(Font.system(size: 18, weight: .semibold))
                                            .foregroundColor(selectedTab == row ? Color.primary : Color.secondary)
                                            .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                    }
                                    .frame(width: geoWidth / CGFloat(tabs.count))
                                    // Bar Indicator
                                    Rectangle().fill(selectedTab == row ? Color.cyan : Color.gray)
                                        .frame(height: 3)
                                }
                                .fixedSize()
                            }).buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
    }
}

struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs(
             tabs: [.init(title: "Tab 1"),
                    .init(title: "Tab 2")],
             geoWidth: 375,
             selectedTab: .constant(0))
    }
}
