//
//  MarketDataInteractor.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Combine
import Foundation
import Entities
import Repositories
import Factory

public protocol MarketDataInteractorProtocol {
    func connect()
    func disconnect()
    func subscribe(topics: [String])
    func unsubscribe(topics: [Topic])
//    func streamOrderBook() -> AsyncThrowingStream<[OrderBookItem], Error>
//    func streamRecentTrade() -> AsyncThrowingStream<[TradeItem], Error>
    var orderBookValueSubject: CurrentValueSubject<[OrderBookItem], Never> { get }
    var tradeValueSubject: CurrentValueSubject<[TradeItem], Never> { get }
}

public final class MarketDataInteractor: MarketDataInteractorProtocol {
    @Injected(\.marketDataRepository) var repository: MarketDataRepositoryProtocol
    private let increment: Decimal = 0.1
    private var orderBookData: [Side: [Decimal: [OrderBookL2Data]]] = [:]
	private var tradeData: [TradeItem] = []
    public var orderBookValueSubject = CurrentValueSubject<[OrderBookItem], Never>([])
    public var tradeValueSubject = CurrentValueSubject<[TradeItem], Never>([])

	public init() {
        orderBookData[.sell] = [:]
        orderBookData[.buy] = [:]
        streamData()
	}

	public func connect() {
		repository.connect()
	}

    public func disconnect() {
		repository.disconnect()
	}

    // TODO: clean up
    func streamData() {
        Task {
            for try await data in self.repository.stream() {
                guard let orderBookL2 = data as? OrderBookL2 else {
                    guard let trade = data as? Trade else {
                        continue
                    }

                    switch trade.action {
                    case .insert:
                        // Map trade data to TradeItems
                        let tradeItems = trade.data.map { TradeItem(
                            side: $0.side,
                            price: $0.price,
                            size: Decimal($0.size),
                            timestamp: $0.timestamp)
                        }
                        self.tradeData.insert(contentsOf: tradeItems.prefix(30), at: 0)
                        self.tradeData = Array(self.tradeData.prefix(30))
                    case .partial:
                        self.tradeData = []
                    case .delete, .update:
                        break
                    }

                    // TODO: optimize this
                    tradeValueSubject.send(self.tradeData)
                    continue
                }

                switch orderBookL2.action {
                case .partial:
                    // Need to reset sellSide, buySide data
                    orderBookData[.sell] = [:]
                    orderBookData[.buy] = [:]
                    for order in orderBookL2.data {
                        let priceIndex = calculatePriceIndex(price: order.price)
                        let side = order.side
                        orderBookData[side]![priceIndex, default: []].append(order)
                    }
                case .update:
                    // Update records
                    for order in orderBookL2.data {
                        // Find order with price index with side
                        let priceIndex = calculatePriceIndex(price: order.price)
                        let side = order.side
                        // TODO: check force cast
                        guard var existOrder = findOrder(orderId: order.id, in: orderBookData[side]![priceIndex, default: []])  else {
                            orderBookData[side]![priceIndex, default: []].append(order)
                            continue
                        }
                        existOrder.updateData(size: order.size ?? .zero, price: order.price, timestamp: order.timestamp) // TODO: handle cannot find
                    }
                case .insert:
                    // Insert new records
                    for order in orderBookL2.data {
                        let priceIndex = calculatePriceIndex(price: order.price)
                        let side = order.side
                        orderBookData[side]![priceIndex, default: []].append(order)
                    }
                case .delete:
                    // Delete records
                    for order in orderBookL2.data {
                        let priceIndex = calculatePriceIndex(price: order.price)
                        let side = order.side
                        orderBookData[side]![priceIndex, default: []].removeAll { $0.id == order.id }
                        if orderBookData[side]![priceIndex, default: []].isEmpty {
                            orderBookData[side]?.removeValue(forKey: priceIndex)
                        }
                    }
                }

                // Generate OrderBookItem from orderBookData
                var orderBookItems: [OrderBookItem] = []
                // Get 20 buy orders and 20 sell orders
                let buyOrders = self.orderBookData[.buy]!.sorted { $0.key > $1.key }.prefix(20)
                let sellOrders = self.orderBookData[.sell]!.sorted { $0.key < $1.key }.prefix(20)
                let totalBuyVolume = buyOrders.reduce(0) { $0 + $1.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } }
                let totalSellVolume = sellOrders.reduce(0) { $0 + $1.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } }
                var accumulatedBuyVolume = Decimal.zero
                var accumulatedSellVolume = Decimal.zero
                for i in 0..<20 {
                    let buyOrder = buyOrders[safe: i]
                    let sellOrder = sellOrders[safe: i]
                    accumulatedBuyVolume += buyOrder?.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } ?? 0
                    accumulatedSellVolume += sellOrder?.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } ?? 0
                    let orderBookItem = OrderBookItem(
                        buyPrice: getPrice(priceIndex: buyOrder?.key ?? .zero),
                        buySize: buyOrder?.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } ?? .zero,
                        buySizePercentage: calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedBuyVolume),
                        sellPrice: getPrice(priceIndex: sellOrder?.key ?? .zero),
                        sellSize: sellOrder?.value.reduce(0) { $0 + Decimal($1.size ?? .zero) } ?? .zero,
                        sellSizePercentage: calculateSize(totalBuyVolume: totalBuyVolume, totalSellVolume: totalSellVolume, accumulatedVolume: accumulatedSellVolume))
                    orderBookItems.append(orderBookItem)
                }
                orderBookValueSubject.send(orderBookItems)
            }
        }
	}

	public func subscribe(topics: [String]) {
        repository.subscribe(topics: topics.compactMap({ Topic(rawValue: $0) }))
	}

    public func unsubscribe(topics: [Topic]) {
		repository.unsubscribe(topics: topics)
	}

	private func calculatePriceIndex(price: Decimal) -> Decimal {
		return price / increment
	}

    private func getPrice(priceIndex: Decimal) -> Decimal {
        return priceIndex * increment
    }

	private func findOrder(orderId: UInt64, in orders: [OrderBookL2Data]) -> OrderBookL2Data? {
		return orders.first { $0.id == orderId }
	}

    private func calculateSize
    (
        totalBuyVolume: Decimal,
        totalSellVolume: Decimal,
        accumulatedVolume: Decimal
    ) -> CGFloat {
        let totalVolume = max(totalBuyVolume, totalSellVolume)
        let size = accumulatedVolume / totalVolume
        return CGFloat(truncating: size as NSNumber)
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
