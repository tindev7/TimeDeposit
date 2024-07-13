//
//  TimeDepositModel.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation

struct Response: Codable {
    let data: [TimeDepositModel]
}

struct TimeDepositModel: Codable, Hashable {
    let productList: [TimeDepositDetailModel]
    let productGroupName: String
}

struct TimeDepositDetailModel: Codable, Hashable {
    var id: UUID? = UUID()
    let rate: Int
    let code: String
    let marketingPoints: [String]
    let productName: String
    let startingAmount: Int
    let isPopular: Bool
}
