//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

// Delegate Method - 1
protocol ItemInfoVCDelegate: AnyObject {
  func didTapGithubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

// Super Class
class GFItemInfoVC: UIViewController {
  let stackView = UIStackView()
  let itemInfoViewOne = GFItemInfoView()
  let itemInfoViewTwo = GFItemInfoView()
  let actionButton = GFButton()
  
  var user: User!
  
  init(user: User!) {
    super.init(nibName: nil, bundle: nil)
    self.user = user
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBackgroundView()
    layoutUI()
    configureStackView()
    configureActionButton()
  }
}

extension GFItemInfoVC {
  
  func configureBackgroundView() {
    view.layer.cornerRadius = 18
    view.backgroundColor = .secondarySystemBackground
  }
  
  func configureStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    
    stackView.addArrangedSubview(itemInfoViewOne)
    stackView.addArrangedSubview(itemInfoViewTwo)
  }
  
  func layoutUI() {
    view.addSubviews(stackView, actionButton)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    let padding: CGFloat = 20
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      stackView.heightAnchor.constraint(equalToConstant: 50),
      
      actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
}

extension GFItemInfoVC {
  
  // Define action for Button with empty Function actionButtonTapped() - 5
  private func configureActionButton() {
    actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
  }
  
  @objc
  func actionButtonTapped() { }
}
