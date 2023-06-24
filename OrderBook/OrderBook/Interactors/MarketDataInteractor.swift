//
//  MarketDataInteractor.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation
import Entities
import Repositories
import Factory

public protocol MarketDataInteractorProtocol {
    func connect()
    func disconnect()
    func subscribe(topics: [String])
    func unsubscribe(topics: [Topic])
    func streamOrderBook() -> AsyncThrowingStream<[OrderBookItem], Error>
}

public final class MarketDataInteractor: MarketDataInteractorProtocol {
    @Injected(\.marketDataRepository) var repository: MarketDataRepositoryProtocol
    private let increment: Decimal = 0.1
    private var orderBookData: [Side: [Decimal: [OrderBookL2Data]]] = [:]

	public init() {
        orderBookData[.sell] = [:]
        orderBookData[.buy] = [:]
	}

	public func connect() {
		repository.connect()
	}

    public func disconnect() {
		repository.disconnect()
	}

    public func streamOrderBook() -> AsyncThrowingStream<[OrderBookItem], Error> {
        return AsyncThrowingStream { continuation in // TODO: weak self
			Task {
				for try await data in self.repository.stream() {
                    guard let orderBookL2 = data as? OrderBookL2 else {
                        continue
                    }

                    switch orderBookL2.action {
                    case .partial:
						// Need to reset sellSide, buySide data
                        orderBookData[.sell] = [:]
                        orderBookData[.buy] = [:]
                    case .update:
						// Update records
						for order in orderBookL2.data {
							// Find order with price index with side
							let priceIndex = calculatePriceIndex(price: order.price)
							let side = order.side
							var existOrder = findOrder(orderId: order.id, in: orderBookData[side]![priceIndex, default: []]) // TODO: check force cast
                            existOrder?.updateData(size: order.size, price: order.price, timestamp: order.timestamp)
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
                        }
                    }

					// Generate OrderBookItem from orderBookData
					var orderBookItems: [OrderBookItem] = []
					// Get 20 buy orders and 20 sell orders
                    let buyOrders = self.orderBookData[.buy]!.sorted { $0.key > $1.key }.prefix(20)
                    let sellOrders = self.orderBookData[.sell]!.sorted { $0.key < $1.key }.prefix(20)
					for i in 0..<20 {
                        let buyOrder = buyOrders[safe: i]
                        let sellOrder = sellOrders[safe: i]
//                        let buyOrderSizePercentage = buyOrder.value.reduce(into: 0) { $0 + $1.sizePercentage }
//                        let sellOrderSizePercentage = sellOrder.value.reduce(into: 0) { $0 + $1.sizePercentage }
                        let orderBookItem = OrderBookItem(
                            buyPrice: getPrice(priceIndex: buyOrder?.key ?? .zero),
                            buySize: buyOrder?.value.reduce(0) { $0 + Decimal($1.size) } ?? .zero,
                            buySizePercentage: 0.3,
                            sellPrice: getPrice(priceIndex: sellOrder?.key ?? .zero),
                            sellSize: sellOrder?.value.reduce(0) { $0 + Decimal($1.size) } ?? .zero,
                            sellSizePercentage: 0.45)
						orderBookItems.append(orderBookItem)
					}
					continuation.yield(orderBookItems)
				}
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
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
