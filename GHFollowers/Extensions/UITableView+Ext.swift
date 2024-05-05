//
//  UITableView.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import UIKit

extension UITableView {
  
  func reloadDataOnMainThread() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
  
  func removeExcessCells() {
    tableFooterView = UIView(frame: .zero)
  }
}
