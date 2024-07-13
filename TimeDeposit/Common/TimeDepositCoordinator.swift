//
//  TimeDepositCoordinator.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation
import UIKit

protocol TimeDepositCoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func start()
    func navigateToDetailPage(timeDepositDetail: TimeDepositTableCellModel)
}

struct TimeDepositCoordinator: TimeDepositCoordinatorProtocol {
    var navigationController: UINavigationController
    
    func start() {
        let dependency: LandingPageViewModelDependency = LandingPageViewModelDependency(coordinator: self, fetcher: Fetcher())

        let landingPageViewModel: LandingPageViewModelProtocol = LandingPageViewModel(dependency: dependency)
        
        let landingPageVc: LandingPageViewController = LandingPageViewController(viewModel: landingPageViewModel)
        
        navigationController.pushViewController(landingPageVc, animated: true)
    }
    
    func navigateToDetailPage(timeDepositDetail: TimeDepositTableCellModel) {
        let dependency: DetailPageViewModelDependency = DetailPageViewModelDependency(
            coordinator: self,
            timeDepositDetail: timeDepositDetail
        )

        let detailPageViewModel: any DetailPageViewModelProtocol = DetailPageViewModel(dependency: dependency)
        
        let detailPageVc: DetailPageViewController = DetailPageViewController(viewModel: detailPageViewModel)
        
        navigationController.pushViewController(detailPageVc, animated: true)
    }
}

