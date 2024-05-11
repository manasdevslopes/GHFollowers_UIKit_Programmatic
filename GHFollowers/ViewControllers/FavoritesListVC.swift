//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
  let tableView = UITableView()
  var favorites: [Follower] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }
  // This is for iOS 17+
  //  override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
  //    if favorites.isEmpty {
  //      var config = UIContentUnavailableConfiguration.empty()
  //      config.image = .init(systemName: "star")
  //      config.text = "No Favorite"
  //      config.secondaryText = "Add a favorite on the favorite list screen"
  //      contentUnavailableConfiguration = config
  //    } else {
  //      contentUnavailableConfiguration = nil
  //    }
  //  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    title = "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureTableView() {
    view.addSubview(tableView)
    
    tableView.frame = view.bounds
    tableView.rowHeight = 80
    tableView.delegate = self
    tableView.dataSource = self
    tableView.removeExcessCells()
    
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
  }
}

// Table View
extension FavoritesListVC: UITableViewDataSource,UITableViewDelegate {
  // Datasource - 1
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  // Datasource - 2
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
    let favorite = favorites[indexPath.row]
    cell.set(favorite: favorite)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = favorites[indexPath.row]
    let descVC = FollowerListVC(username: favorite.login)
    navigationController?.pushViewController(descVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
      guard let self else { return }
      guard let error else {
        self.favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        if self.favorites.isEmpty {
          self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
        }
        // setNeedsUpdateContentUnavailableConfigure()
        return
      }
      DispatchQueue.main.async {
        self.presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

extension FavoritesListVC {
  func getFavorites() {
    PersistenceManager.retrieveFavorites { [weak self] result in
      guard let self else { return }
      switch result {
        case .success(let favorites): self.updateUI(with: favorites)
        case .failure(let error):
          DispatchQueue.main.async {
            self.presentGFAlert(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
          }
      }
    }
  }
  
  func updateUI(with favorites: [Follower]) {
    if favorites.isEmpty {
      self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
    } else {
      self.favorites = favorites
      // setNeedsUpdateContentUnavailableConfigure()
      // self.tableView.reloadDataOnMainThread()
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.view.bringSubviewToFront(self.tableView)
      }
    }
  }
}
