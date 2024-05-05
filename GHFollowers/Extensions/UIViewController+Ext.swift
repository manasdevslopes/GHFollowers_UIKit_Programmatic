//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import UIKit
import SafariServices

extension UIViewController {
  
  func presentGFAlert(title: String, message: String, buttonTitle: String) {
    let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
  }
  
  func presentDefaultError() {
    let alertVC = GFAlertVC(title: "Something went wrong", message: "We were unable to complete your tasks at this time. Please try again.", buttonTitle: "Ok")
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
  }
  
//  func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
//    DispatchQueue.main.async {
//      let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
//      alertVC.modalPresentationStyle = .overFullScreen
//      alertVC.modalTransitionStyle = .crossDissolve
//      self.present(alertVC, animated: true)
//    }
//  }
  
  func presentSafariVC(with url: URL) {
    let safariVC = SFSafariViewController(url: url)
    safariVC.preferredBarTintColor = .systemGreen
    present(safariVC, animated: true)
  }
}
