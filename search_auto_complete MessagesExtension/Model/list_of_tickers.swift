//
//  list_of_tickers.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/18/21.
//

import Foundation

struct Ticker: Codable {
    let symbol: String
    let securityName: String

    enum CodingKeys: String, CodingKey {
        case symbol = "Symbol"
        case securityName = "Security_Name"
    }
}


struct Root: Codable {
    let last: Last
    let status, symbol: String
}

// MARK: - Last gets the last price of the stock
struct Last: Codable {
    let cond1, cond2, cond3, cond4: Int
    let exchange: Int
    let price: Double
    let size: Int
    let timestamp: Double
}

