//
//  Action.swift
//  Models
//
//  Created by Đinh Văn Nhật on 2023/06/19.
//

import Foundation

public enum Action: String, Decodable {
    // The type of the message. Types:
    // 'partial'; This is a table image, replace your data entirely.
    // 'update': Update a single row.
    // 'insert': Insert a new row.
    // 'delete': Delete a row.
	case partial = "partial"
    case update = "update"
	case insert = "insert"
    case delete = "delete"
}
