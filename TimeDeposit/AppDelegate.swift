//
//  AppDelegate.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 08/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: TimeDepositCoordinatorProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Create the window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Set the root view controller
        let navigationController: UINavigationController = UINavigationController()
        
        let coordinator = TimeDepositCoordinator(navigationController: window?.rootViewController?.navigationController ?? UINavigationController())
        
        let dependency: LandingPageViewModelDependency = LandingPageViewModelDependency(coordinator: coordinator, fetcher: Fetcher())

        let landingPageViewModel: LandingPageViewModelProtocol = LandingPageViewModel(dependency: dependency)
        
        let landingPageVc: LandingPageViewController = LandingPageViewController(viewModel: landingPageViewModel)
        
        window?.rootViewController = landingPageVc
        window?.rootViewController?.view.backgroundColor = .white
        
        // Make the window visible
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

