//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Minseong Kang on 2023/04/14.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let firstViewController = HomeViewController()
		let secondViewController = SearchViewController()
		let thirdViewController = LibraryViewController()
		
		firstViewController.title = "Home"
		secondViewController.title = "Search"
		thirdViewController.title = "Library"
		
		firstViewController.navigationItem.largeTitleDisplayMode = .always
		secondViewController.navigationItem.largeTitleDisplayMode = .always
		thirdViewController.navigationItem.largeTitleDisplayMode = .always
		
		let firstNaviController = UINavigationController(rootViewController: firstViewController)
		let secondNaviController = UINavigationController(rootViewController: secondViewController)
		let thirdNaviController = UINavigationController(rootViewController: thirdViewController)
		
		firstNaviController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
		secondNaviController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
		thirdNaviController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
		
		firstNaviController.navigationBar.prefersLargeTitles = true
		secondNaviController.navigationBar.prefersLargeTitles = true
		thirdNaviController.navigationBar.prefersLargeTitles = true
		
		setViewControllers([firstNaviController, secondNaviController, thirdNaviController], animated: false)
    }
    


}
