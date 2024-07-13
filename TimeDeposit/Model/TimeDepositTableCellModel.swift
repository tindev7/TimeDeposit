//
//  TimeDepositTableCellModel.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation

struct TimeDepositTableCellModel: Codable, Hashable, Equatable {
    var id: UUID? = UUID()
    var rate: Int
    var code: String
    var marketingPoints: [String]
    var productName: String
    var startingAmount: Int
    var isPopular: Bool
}
