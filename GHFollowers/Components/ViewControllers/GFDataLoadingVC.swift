//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 09/05/24.
//

import UIKit

class GFDataLoadingVC: UIViewController {
  
  var containerView: UIView!
  var emptyStateView: UIView!
  
  func showLoadingView() {
    containerView = UIView(frame: view.bounds)
    view.addSubview(containerView)
    
    containerView.backgroundColor = .systemBackground
    containerView.alpha = 0
    
    UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    containerView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
  
  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.containerView.removeFromSuperview()
      self.containerView = nil
    }
  }
  
  func showEmptyStateView(with message: String, in view: UIView) {
    emptyStateView = GFEmptyStateView(message: message)
    emptyStateView.frame = view.bounds
    view.addSubview(emptyStateView)
  }
  
  func removeEmptyStateViews() {
    DispatchQueue.main.async {
      self.emptyStateView.removeFromSuperview()
      self.emptyStateView = nil
    }
  }
  
  func removeEmptyStateView() {
    DispatchQueue.main.async {
      if let view = self.emptyStateView {
        view.removeFromSuperview()
      }
    }
  }
}
