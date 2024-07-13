//
//  LandingPageViewModel.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 08/07/24.
//

import Foundation

struct LandingPageViewModelDependency {
    let coordinator: TimeDepositCoordinatorProtocol
    let fetcher: Fetcher
}

protocol LandingPageViewModelAction: AnyObject {
    func viewModelShouldSetupView()
    func viewModelShouldConfigureLoading(isLoading: Bool, currentPage: Int)
    func viewModelShouldConfigureHeader(by viewModel: LandingPageTabbarViewModel)
    func viewModelShouldUpdateTimeDepositList(productGroupName: String, by list: [TimeDepositTableCellModel])
}

protocol LandingPageViewModelProtocol {
    var action: LandingPageViewModelAction? { get set }
    
    var displayedTimeDeposit: [TimeDepositTableCellModel] { get }
    
    func onLoad()
    func openButtonTapped(item: TimeDepositTableCellModel)
}

final class LandingPageViewModel: LandingPageViewModelProtocol {
    weak var action: LandingPageViewModelAction?
    
    private let dependency: LandingPageViewModelDependency
    
    // Product Groupname string with List of Time Deposit Detail 
    private var timeDepositDict: [String: [TimeDepositTableCellModel]] = [:]
    private var currentPage: Int = 0
    
    var displayedProductGroupNames: String = ""
    var displayedTimeDeposit: [TimeDepositTableCellModel] = []
    
    init(dependency: LandingPageViewModelDependency) {
        self.dependency = dependency
    }
    
    func onLoad() {
        action?.viewModelShouldSetupView()
        action?.viewModelShouldConfigureLoading(isLoading: true, currentPage: currentPage)
        
        dependency.fetcher.fetchTimeDeposit(completion: { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let timeDepositList):
                guard !timeDepositList.isEmpty else {
                    // Handle empty state
                    return
                }
                strongSelf.action?.viewModelShouldConfigureLoading(isLoading: false, currentPage: strongSelf.currentPage)
                strongSelf.configureHeaderViewModel(timeDepositList: timeDepositList)
                strongSelf.configureTimeDepositList(timeDepositList: timeDepositList)
                
                strongSelf.currentPage += 1
            case .failure(let error):
                strongSelf.action?.viewModelShouldConfigureLoading(isLoading: false, currentPage: 0)
            }
        })
    }
    
    func openButtonTapped(item: TimeDepositTableCellModel) {
        dependency.coordinator.navigateToDetailPage(timeDepositDetail: item)
    }
}

// MARK: - Private Functions
private extension LandingPageViewModel {
    func configureHeaderViewModel(timeDepositList: [TimeDepositModel]) {
        guard currentPage == 0 else { return } // No need to reconfigure header when pagination called
        let productGroupNames: [String] = timeDepositList.map { $0.productGroupName }
        
        let dependency: LandingPageTabbarViewModelDependency = LandingPageTabbarViewModelDependency(productGroupNames: productGroupNames)
        
        let viewModel: LandingPageTabbarViewModel = LandingPageTabbarViewModel(dependency: dependency)
        viewModel.delegate = self
        
        action?.viewModelShouldConfigureHeader(by: viewModel)
    }
    
    func configureTimeDepositList(timeDepositList: [TimeDepositModel]) {
        guard currentPage == 0 else {
            // Load more
            guard let timeDepositSelectedIndex: Int = timeDepositList.firstIndex(where: { $0.productGroupName == displayedProductGroupNames}) else { return }
            var currentTimeDepositList: [TimeDepositTableCellModel] = timeDepositDict[displayedProductGroupNames] ?? []
            
            let cellModelList: [TimeDepositTableCellModel] = timeDepositList[timeDepositSelectedIndex].productList.map { item in
                let cellModel: TimeDepositTableCellModel = TimeDepositTableCellModel(
                    rate: item.rate,
                    code: item.code,
                    marketingPoints: item.marketingPoints,
                    productName: item.productName,
                    startingAmount: item.startingAmount,
                    isPopular: item.isPopular
                )
                return cellModel
            }
            currentTimeDepositList.append(contentsOf: cellModelList)
            timeDepositDict[displayedProductGroupNames] = currentTimeDepositList
            
            displayedTimeDeposit = currentTimeDepositList
            
            action?.viewModelShouldUpdateTimeDepositList(
                productGroupName: displayedProductGroupNames,
                by: currentTimeDepositList
            )
            
            return
        }
        timeDepositList.forEach {
            if timeDepositDict[$0.productGroupName]?.isEmpty ?? true {
                let cellModelList: [TimeDepositTableCellModel] = $0.productList.map { item in
                    let cellModel: TimeDepositTableCellModel = TimeDepositTableCellModel(
                        rate: item.rate,
                        code: item.code,
                        marketingPoints: item.marketingPoints,
                        productName: item.productName,
                        startingAmount: item.startingAmount,
                        isPopular: item.isPopular
                    )
                    return cellModel
                }
                timeDepositDict[$0.productGroupName] = cellModelList
            }
        }
        
        let cellModelList: [TimeDepositTableCellModel] = timeDepositList.first?.productList.map { item in
            let cellModel: TimeDepositTableCellModel = TimeDepositTableCellModel(
                rate: item.rate,
                code: item.code,
                marketingPoints: item.marketingPoints,
                productName: item.productName,
                startingAmount: item.startingAmount,
                isPopular: item.isPopular
            )
            
            return cellModel
        } ?? []
        displayedProductGroupNames = timeDepositList.first?.productGroupName ?? ""
        displayedTimeDeposit = cellModelList
        
        action?.viewModelShouldUpdateTimeDepositList(
            productGroupName: timeDepositList.first?.productGroupName ?? "",
            by: cellModelList
        )
    }
}

// MARK: - LandingPageTabbarViewModelDelegate
extension LandingPageViewModel: LandingPageTabbarViewModelDelegate {
    func tabbarDidTapped(productGroupName: String) {
        guard let timeDepositDetailList: [TimeDepositTableCellModel] = timeDepositDict[productGroupName] else { return }
        displayedProductGroupNames = productGroupName
        displayedTimeDeposit = timeDepositDetailList
        
        action?.viewModelShouldUpdateTimeDepositList(productGroupName: productGroupName, by: timeDepositDetailList)
    }
}
