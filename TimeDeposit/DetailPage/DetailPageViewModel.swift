//
//  DetailPageViewModel.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation
import UIKit

struct DetailPageViewModelDependency {
    let coordinator: TimeDepositCoordinatorProtocol
    let timeDepositDetail: TimeDepositTableCellModel
}

protocol DetailPageViewModelAction: AnyObject {
    func viewModelShouldSetupView()
}

protocol DetailPageViewModelProtocol: ObservableObject {
    var action: DetailPageViewModelAction? { get set }
    
    func onLoad()
}

final class DetailPageViewModel: DetailPageViewModelProtocol {
    weak var action: DetailPageViewModelAction?
    
    let dependency: DetailPageViewModelDependency
    
    init(dependency: DetailPageViewModelDependency) {
        self.dependency = dependency
    }
    
    func onLoad() {
        action?.viewModelShouldSetupView()
    }
    
    func openTnc() {
        guard let neoBankUrl: URL = URL(string: "https://www.bankneocommerce.co.id/id/home") else { return }
        UIApplication.shared.open(neoBankUrl)
    }
}

// MARK: - Private Functions
private extension DetailPageViewModel {
    
}
