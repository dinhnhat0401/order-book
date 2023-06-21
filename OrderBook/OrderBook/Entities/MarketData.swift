//
//  MarketData.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/20.
//

import Foundation

public protocol MarketDataResponseProtocol {
	var table: String { get }
	var action: Action { get }
}
