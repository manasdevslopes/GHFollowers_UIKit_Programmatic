//
//  Follower.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import Foundation

struct Follower: Codable, Hashable {
  var login: String
  var avatarUrl: String
  
  private enum CodingKeys: String, CodingKey {
    case login
    case avatarUrl = "avatar_url"
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(login)
  }
}
