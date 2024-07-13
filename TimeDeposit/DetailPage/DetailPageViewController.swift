//
//  DetailPageViewController.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import SwiftUI
import UIKit

class DetailPageViewController: UIViewController {

    private var viewModel: any DetailPageViewModelProtocol
    
    // MARK: Initialize
    init(viewModel: any DetailPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onLoad()
    }
}

// MARK: - Private Functions
private extension DetailPageViewController {
    
}

// MARK: - DetailPageViewModelAction
extension DetailPageViewController: DetailPageViewModelAction {
    func viewModelShouldSetupView() {
        view.backgroundColor = .white
        
        guard let viewModel: DetailPageViewModel = viewModel as? DetailPageViewModel else { return }
            
        let detailViewController: UIHostingController = UIHostingController(rootView: DetailPageView(viewModel: viewModel))
        addChild(detailViewController)
        detailViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailViewController.view)
        detailViewController.view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            detailViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            detailViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        detailViewController.didMove(toParent: self)
    }
}
