//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
  var username: String!
  var followers: [Follower] = []
  var filteredFollowers: [Follower] = []
  var page = 1
  var hasMoreFollowers = true
  var isSearching = false
  var isLoadingMoreFollowers = false
  
  var collectionView: UICollectionView!
  // UICollectionViewDiffableDataSource - DiffableDataSource is a New way to handle data in collection View and TableView. With all Delegate methods and Animations. UICollectionViewDiffableDataSource takes Sections And Objects. Both in hashable.
  enum Section { // By default enums are hashable
    case main
  }
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username = username
    title = username
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureCollectionView()
    getFollower(username: username, page: page)
    configureDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  // This is for iOS 17+
  //  override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
  //    if followers.isEmpty && !isLoadingMoreFollowers {
  //      var config = UIContentUnavailableConfiguration.empty()
  //      config.image = .init(systemName: "person.slash")
  //      config.text = "No Followers"
  //      config.secondaryText = "This user doesn't have any followers. Go follow them 😀."
  //      contentUnavailableConfiguration = config
  //    } else if isSearching && filteredFollowers.isEmpty {
  //      contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
  //    } else {
  //      contentUnavailableConfiguration = nil
  //    }
  //  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
}

// configure CollectionView & creating Custom UICollectionViewFlowLayout
extension FollowerListVC {
  func configureCollectionView() {
    // First initialise Collection View
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    // Configure CollectionView Delegate
    collectionView.delegate = self
    
    // Second, then add it in SubView
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
  }
}

// Now Configure DiffableDataSource
extension FollowerListVC {
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
      cell.set(follower: follower)
      return cell
    })
  }
  
  func updateData(on followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  @objc func addButtonTapped() {
    showLoadingView()
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        addUserToFavorites(user: user)
        self.dismissLoadingView()
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
    }
    
    //    NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
    //      guard let self else { return }
    //      self.dismissLoadingView()
    //
    //      switch result {
    //        case .success(let user): addUserToFavorites(user: user)
    //        case .failure(let error):
    //          self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
    //      }
    //    }
  }
  
  func addUserToFavorites(user: User) {
    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
      guard let self else { return }
      guard let error else {
        DispatchQueue.main.async {
          self.presentGFAlert(title: "Success!", message: "You've successfully favorited \(user.name ?? "") user 🎉", buttonTitle: "Hooray!")
        }
        return
      }
      
      DispatchQueue.main.async {
        self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

// API call
extension FollowerListVC {
  func getFollower(username: String, page: Int) {
    print("username", username, "page", page)
    showLoadingView()
    isLoadingMoreFollowers = true
    
    Task {
      do {
        let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
        dismissLoadingView()
        updateUI(with: followers)
        self.isLoadingMoreFollowers = false
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Bad Stuff Happened", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
    }
  }
  
  func updateUI(with followers: [Follower]) {
    if followers.count < 100 { self.hasMoreFollowers = false }
    self.followers.append(contentsOf: followers)
    
    if self.followers.isEmpty {
      let message = "This user doesn't have any followers. Go follow them 😃."
      DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
      return
    }
    self.updateData(on: self.followers)
    //    setNeedsUpdateContentUnavailableConfiguration() // iOS 17+
  }
}

// Now Conform to this Delegate UserInfoVCDelegate - 9
extension FollowerListVC: UserInfoVCDelegate {
  func didRequestFollowers(for username: String) {
    self.username = username
    title = username
    page = 1
    followers.removeAll()
    filteredFollowers.removeAll()
    // collectionView.setContentOffset(.zero, animated: true)
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    getFollower(username: username, page: page)
  }
}

// CollectionView Delegate - UICollectionViewDelegate
extension FollowerListVC: UICollectionViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y // How much Scroll Completes
    let contentHeight = scrollView.contentSize.height // Total height of Content
    let height = scrollView.frame.size.height // Height of the Frame / Screen
    
    print("offsetY=========>", offsetY)
    print("contentHeight===>", contentHeight)
    print("height==========>", height)
    
    if (offsetY > (contentHeight - height)) {
      guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
      page += 1
      getFollower(username: username, page: page)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let activeArray = isSearching ? filteredFollowers : followers
    let follower = activeArray[indexPath.item]
    
    let descVC = UserInfoVC()
    descVC.username = follower.login
    // Now, add delegate to self class
    descVC.delegate = self
    
    let navController = UINavigationController(rootViewController: descVC)
    // to open model
    present(navController, animated: true)
  }
}

// Search Controller Delegate - UISearchResultsUpdating
extension FollowerListVC: UISearchResultsUpdating {
  // listens for searchController from UISearchResultsUpdating
  func updateSearchResults(for searchController: UISearchController) {
    self.removeEmptyStateView()
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      filteredFollowers.removeAll()
      updateData(on: followers)
      isSearching = false
      return
    }
    isSearching = true
    filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
    
    if self.filteredFollowers.isEmpty {
      let message = "No results. Pls try again with different username 🥺."
      DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
    }
    self.updateData(on: filteredFollowers)
    //    setNeedsUpdateContentUnavailableConfiguration() // iOS 17+
  }
  
  // This is for when cross icon clicked, when search Text is empty
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        searchBar.resignFirstResponder()
        self.isSearching = false
        self.updateData(on: self.followers)
      }
    }
  }
  
  // This is for configure Search Controller, also assigns all delegates to self
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search for a username"
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
  }
}
