//
//  LandingPageTabbarViewModel.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 08/07/24.
//

import Foundation
import SwiftUI

protocol LandingPageTabbarViewModelDelegate: AnyObject {
    func tabbarDidTapped(productGroupName: String)
}

struct LandingPageTabbarViewModelDependency {
    let productGroupNames: [String]
}

final class LandingPageTabbarViewModel: ObservableObject {
    @Published
    var selectedIndex: Int = 0
    
    var productGroupNames: [String] = []
    
    weak var delegate: LandingPageTabbarViewModelDelegate?
    
    init(dependency: LandingPageTabbarViewModelDependency) {
        productGroupNames = dependency.productGroupNames
    }
    
    func tabbarDidTapped(index: Int) {
        guard index < productGroupNames.count else { return }
        selectedIndex = index
        
        delegate?.tabbarDidTapped(productGroupName: productGroupNames[index])
    }
}
