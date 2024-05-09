//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

// Delegate Method - 1
protocol GFFollowerItemVCDelegate: AnyObject {
  func didTapGetFollowers(for user: User)
}

// Sub Class 2 of SuperClass GFItemInfoVC
class GFFollowerItemVC: GFItemInfoVC {
  // Now add GFRepoItemVCDelegate delegate to this super class so that its subclasses can use this delegate to call their specific method - 3
  // Also add 'weak', to prevent the retain cycle
  weak var delegate: GFFollowerItemVCDelegate!
  
  init(user: User, delegate: GFFollowerItemVCDelegate!) {
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
    itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
    itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
    actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
  }
  
  // Override actionButtonTapped func with the required delegate method - 7
  override func actionButtonTapped() {
    delegate.didTapGetFollowers(for: user)
  }
}
