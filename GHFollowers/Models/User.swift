//
//  User.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import Foundation

struct User: Codable {
  let login: String
  let avatarUrl: String
  var name: String?
  var location: String?
  var bio: String?
  let publicRepos: Int
  let publicGists: Int
  let htmlUrl: String
  let following: Int
  let followers: Int
  let createdAt: Date
  
  private enum CodingKeys: String, CodingKey {
    case login
    case avatarUrl = "avatar_url"
    case name, location, bio
    case publicRepos = "public_repos"
    case publicGists = "public_gists"
    case htmlUrl = "html_url"
    case following, followers
    case createdAt = "created_at"
  }
}
