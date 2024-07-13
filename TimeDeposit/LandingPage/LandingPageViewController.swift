//
//  LandingPageViewController.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 08/07/24.
//

import Foundation
import UIKit
import SwiftUI

class LandingPageViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "Wealth"
        
        return label
    }()
    
    private lazy var tabbarContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var productGroupNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var timeDepositTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(DepositoCardTableViewCell.self, forCellReuseIdentifier: "DepositoCardTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 8.0
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, TimeDepositTableCellModel> =
        UITableViewDiffableDataSource<Int, TimeDepositTableCellModel>(tableView: timeDepositTableView, cellProvider: { [weak self] tableView, indexPath, value -> UITableViewCell? in
            guard
                let self,
                let cell: DepositoCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositoCardTableViewCell", for: indexPath) as? DepositoCardTableViewCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configureCell(timeDepositModel: value, isLastCell: indexPath.row == viewModel.displayedTimeDeposit.count - 1)
            return cell
        })
    
    private lazy var loadingIndicator = UIActivityIndicatorView(style: .large)
    private lazy var footerLoadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private var viewModel: LandingPageViewModelProtocol
    
    // MARK: Initialize
    init(viewModel: LandingPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onLoad()
    }
    
}

// MARK: - Private Functions
private extension LandingPageViewController {
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}

extension LandingPageViewController: LandingPageViewModelAction {
    func viewModelShouldSetupView() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, tabbarContainerView, productGroupNameLabel, timeDepositTableView])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            
            tabbarContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            tabbarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productGroupNameLabel.topAnchor.constraint(equalTo: tabbarContainerView.bottomAnchor, constant: 8.0),
            productGroupNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            productGroupNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            
            timeDepositTableView.topAnchor.constraint(equalTo: productGroupNameLabel.bottomAnchor, constant: 8.0),
            timeDepositTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            timeDepositTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            timeDepositTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func viewModelShouldConfigureLoading(isLoading: Bool, currentPage: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard currentPage == 0 else {
                // Loading pagination
                if isLoading {
                    timeDepositTableView.tableFooterView = footerLoadingIndicator
                    footerLoadingIndicator.startAnimating()
                }
                else {
                    timeDepositTableView.tableFooterView = nil
                    footerLoadingIndicator.stopAnimating()
                }
                return
            }
            // Loading initial state
            self.titleLabel.isHidden = isLoading
            self.tabbarContainerView.isHidden = isLoading
            self.productGroupNameLabel.isHidden = isLoading
            self.timeDepositTableView.isHidden = isLoading
            
            guard isLoading else {
                if self.loadingIndicator.isDescendant(of: view) {
                    self.loadingIndicator.removeFromSuperview()
                }
                
                self.hideLoadingIndicator()
                return
            }
            
            if !self.loadingIndicator.isDescendant(of: view) {
                // Set up the loading indicator
                self.loadingIndicator.center = view.center
                self.loadingIndicator.hidesWhenStopped = true
                view.addSubview(self.loadingIndicator)
            }
            
            self.showLoadingIndicator()
        }
    }
    
    func viewModelShouldConfigureHeader(by viewModel: LandingPageTabbarViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let tabbarHostingViewController: UIHostingController = UIHostingController(rootView: LandingPageTabbarView(viewModel: viewModel))
            addChild(tabbarHostingViewController)
            tabbarHostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
            tabbarContainerView.addSubview(tabbarHostingViewController.view)
            
            tabbarHostingViewController.didMove(toParent: self)
            
            // Setup constraints for the SwiftUI view
            NSLayoutConstraint.activate([
                tabbarHostingViewController.view.topAnchor.constraint(equalTo: tabbarContainerView.topAnchor),
                tabbarHostingViewController.view.leadingAnchor.constraint(equalTo: tabbarContainerView.leadingAnchor),
                tabbarHostingViewController.view.trailingAnchor.constraint(equalTo: tabbarContainerView.trailingAnchor),
                tabbarHostingViewController.view.bottomAnchor.constraint(equalTo: tabbarContainerView.bottomAnchor),
            ])
        }
    }
    
    func viewModelShouldUpdateTimeDepositList(productGroupName: String, by list: [TimeDepositTableCellModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.productGroupNameLabel.text = productGroupName
            
            var snapshot: NSDiffableDataSourceSnapshot<Int, TimeDepositTableCellModel> = NSDiffableDataSourceSnapshot<Int, TimeDepositTableCellModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(list)
            
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: - DepositoCardTableViewCellDelegate
extension LandingPageViewController: DepositoCardTableViewCellDelegate {
    func openButtonTapped(item: TimeDepositTableCellModel) {
        viewModel.openButtonTapped(item: item)
    }
}

// MARK: - UITableViewDelegate
extension LandingPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.displayedTimeDeposit.count - 1 { // last cell
            viewModel.onLoad()
        }
    }
}
