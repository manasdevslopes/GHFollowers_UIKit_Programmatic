//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

// Delegate Method - 1
protocol GFRepoItemVCDelegate: AnyObject {
  func didTapGithubProfile(for user: User)
}

// Sub Class 1 of SuperClass GFItemInfoVC
class GFRepoItemVC: GFItemInfoVC {
  
  // Now add GFRepoItemVCDelegate delegate to this super class so that its subclasses can use this delegate to call their specific method - 3
  // Also add 'weak', to prevent the retain cycle
  weak var delegate: GFRepoItemVCDelegate!
  
  init(user: User, delegate: GFRepoItemVCDelegate!) {
    super.init(user: user)
    self.delegate = delegate
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
    actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
  }
  
  // Override actionButtonTapped func with the required delegate method - 6
  override func actionButtonTapped() {
    delegate.didTapGithubProfile(for: user)
  }
}
