//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

// Now create delegate for FollowerListVC to call FollowerList API - 8
protocol UserInfoVCDelegate: AnyObject {
  func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
  let scrollView = UIScrollView()
  let contentView = UIView()
  
  let headerView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  
  var username: String!
  
  // Now, initialise this userInfoVC with delegate of FollowerListVC
  weak var delegate: UserInfoVCDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureScrollView()
    layoutUI()
    
    print("Username: \(String(describing: username))")
    getUserInfo()
  }
}

extension UserInfoVC {
  func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.pinToEdges(of: view)
    contentView.pinToEdges(of: scrollView)
    
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 600)
    ])
  }
}

extension UserInfoVC {
  func getUserInfo() {
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        self.configureUIElements(with: user)
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
      }
    }
  }
  
  func configureUIElements(with user: User) {
    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
    // Now, add both sub classes delegate to self (for this VC) - 4
    self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
    self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
    self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
  }
}

extension UserInfoVC {
  func configureViewController() {
    view.backgroundColor = .systemBackground
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
  
  func layoutUI() {
    itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    for itemView in self.itemViews {
      contentView.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
      ])
    }
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 210),
      
      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
      
      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
      
      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
}

// Make ext with GFRepoItemVCDelegate and their methods - 2
extension UserInfoVC: GFRepoItemVCDelegate {
  func didTapGithubProfile(for user: User) {
    // Show safari View Controller
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlert(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
      return
    }
    presentSafariVC(with: url)
  }
}

// Make ext with GFFollowerItemVCDelegate and their methods - 2
extension UserInfoVC: GFFollowerItemVCDelegate {
  func didTapGetFollowers(for user: User) {
    guard user.followers != 0 else {
      presentGFAlert(title: "No Followers", message: "This user has no followers. What a shame 🧐.", buttonTitle: "So sad")
      return
    }
    // tell follower list screen the new user
    delegate.didRequestFollowers(for: user.login)
    // Dismiss the VC
    dismissVC()
  }
}


