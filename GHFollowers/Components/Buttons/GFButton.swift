//
//  GFButton.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import UIKit

class GFButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  // Required to add as we are not using Storyboard
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Convenience Init
  convenience init(color: UIColor, title: String, systemImageName: String) {
    self.init(frame: .zero)
    set(color: color, title: title, systemImageName: systemImageName)
  }
  
  private func configure() {
    configuration = .tinted()
    configuration?.cornerStyle = .medium
    translatesAutoresizingMaskIntoConstraints = false
  }

  func set(color: UIColor, title: String, systemImageName: String) {
    configuration?.baseBackgroundColor = color
    configuration?.baseForegroundColor = color
    configuration?.title = title
    configuration?.image = UIImage(systemName: systemImageName)
    configuration?.imagePadding = 6
    configuration?.imagePlacement = .leading
  }
}

//#Preview {
//  GFButton(color: .blue, title: "Testing Button", systemImageName: "pencil")
//}
