//
//  GFError.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import Foundation

// Raw Value Enum
enum GFError: String, Error {
  
case invalidUsername = "This username created an invalid request. Please try again."
case unableToComplete = "Unable to complete your request. Please check your network connection"
case invalidResponse = "Invalid repsonse from the server. Please try again."
case invalidData = "The data received from the server was invalid. Please try again"
case unableToFavorites = "There was an error favoriting this user. Please try again."
case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}

