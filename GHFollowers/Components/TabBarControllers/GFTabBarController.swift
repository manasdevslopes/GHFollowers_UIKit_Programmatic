//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

class GFTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UITabBar.appearance().tintColor = .green
    viewControllers = [createSeachNC(), createFavoriteNC()]
  }
  
  // NAVIGATION CONTROLLERS
  func createSeachNC() -> UINavigationController {
    let searchVC = SearchVC()
    searchVC.title = "Search"
    searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    return UINavigationController(rootViewController: searchVC)
  }
  
  func createFavoriteNC() -> UINavigationController {
    let favoriteListVC = FavoritesListVC()
    favoriteListVC.title = "Favorites"
    favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
    return UINavigationController(rootViewController: favoriteListVC)
  }
}
