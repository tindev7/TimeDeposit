//
//  UIView+Extension.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
