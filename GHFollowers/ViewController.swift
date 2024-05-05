//
//  ViewController.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import UIKit

class ViewController: UIViewController {

  lazy private var sampleLable: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Hello World!"
    label.textColor = UIColor.white
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black
    view.addSubview(sampleLable)
    configure()
  }

  func configure() {
    NSLayoutConstraint.activate([
      sampleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      sampleLable.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

}

