//
//  Int+Extension.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation

extension Int {
    func formattedAmount(currency: String = "Rp") -> String {
        let suffixes = ["", "rb", "jt", "mlyr", "trln"]
        var index = 0
        var amount = Double(self)
        
        while amount >= 1000 && index < suffixes.count - 1 {
            amount /= 1000
            index += 1
        }
        
        // Format to one decimal place if necessary
        let formattedAmount = String(format: "%.1f", amount).replacingOccurrences(of: ".0", with: "")
        return "\(currency) \(formattedAmount)\(suffixes[index])"
    }
}
