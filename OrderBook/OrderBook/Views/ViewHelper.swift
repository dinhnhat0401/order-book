//
//  ViewHelper.swift
//  OrderBook
//
//  Created by Đinh Văn Nhật on 2023/06/24.
//

import Foundation
import SwiftUI

struct ViewHelper {
	static func convertTimestampToTime(_ timestamp: String) -> String {
		// Time format: 2023-06-19T12:48:38.151Z
		let inputDateFormat = DateFormatter()
		inputDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		guard let date = inputDateFormat.date(from: timestamp) else {
			return ""
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm:ss"
		return dateFormatter.string(from: date)
	}
}

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
