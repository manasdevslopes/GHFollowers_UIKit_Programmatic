//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import UIKit

class NetworkManager {
  
  static let shared = NetworkManager()
  let cache = NSCache<NSString, UIImage>()
  private let baseURL = "https://api.github.com/users/"
  private let perPage = 100
  let decoder = JSONDecoder()
  
  private init() {
    // decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
  }
  
  // Async / Await way
  func getFollowers(for username: String, page: Int) async throws -> [Follower] {
    let endPoint = baseURL + "\(username)/followers?per_page=\(perPage)&page=\(page)"
    guard let url = URL(string: endPoint) else {
      throw GFError.invalidUsername
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw GFError.invalidResponse
    }
    
    do {
      return try decoder.decode([Follower].self, from: data)
    } catch {
      throw GFError.invalidData
    }
  }
  
  // Async / Await way
  func getUserInfo(for username: String) async throws -> User {
    let endPoint = baseURL + "\(username)"
    
    guard let url = URL(string: endPoint) else {
      throw GFError.invalidUsername
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw GFError.invalidResponse
    }
    
    do {
      return try decoder.decode(User.self, from: data)
    } catch {
      throw GFError.invalidData
    }
  }
}

extension NetworkManager {
  func downloadImage(from urlString: String) async -> UIImage? {
    let cachekey = NSString(string: urlString)
    if let image = cache.object(forKey: cachekey) { return image }
    guard let url = URL(string: urlString) else { return nil }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let image = UIImage(data: data) else { return nil }
      self.cache.setObject(image, forKey: cachekey)
      return image
    } catch {
      return nil
    }
  }
  //  func downloadImage1(from urlString: String, completed: @escaping (UIImage?) -> ()) {
  //    let cachekey = NSString(string: urlString)
  //    if let image = cache.object(forKey: cachekey) {
  //      completed(image)
  //      return
  //    }
  //    guard let url = URL(string: urlString) else {
  //      completed(nil)
  //      return
  //    }
  //
  //    let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
  //      guard let self,
  //            error == nil,
  //            let response = response as? HTTPURLResponse,
  //            response.statusCode == 200,
  //            let data,
  //            let image = UIImage(data: data)
  //      else {
  //        completed(nil)
  //        return
  //      }
  //
  //      self.cache.setObject(image, forKey: cachekey)
  //
  //      completed(image)
  //    }
  //    task.resume()
  //  }
}

// @escaoing Closure; CompletionHandler way
//func getFollowers(for username: String, page: Int, completion: @escaping(Result<[Follower], GFError>) -> ()) {
//  let endPoint = baseURL + "\(username)/followers?per_page=\(perPage)&page=\(page)"
//  guard let url = URL(string: endPoint) else {
//    completion(.failure(.invalidUsername))
//    return
//  }
//
//  let task = URLSession.shared.dataTask(with: url) { data, response, error in
//    if let _ = error {
//      completion(.failure(.unableToComplete)); return
//    }
//
//    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//      completion(.failure(.invalidResponse)); return
//    }
//
//    guard let data else { completion(.failure(.invalidData)); return }
//
//    do {
//      let decoder = JSONDecoder()
//      let followers = try decoder.decode([Follower].self, from: data)
//      completion(.success(followers))
//    } catch {
//      completion(.failure(.invalidData))
//    }
//  }
//
//  task.resume()
//}

// @escaoing Closure; CompletionHandler way
//func getUserInfo(for username: String, completion: @escaping(Result<User, GFError>) -> ()) {
//  let endPoint = baseURL + "\(username)"
//
//  guard let url = URL(string: endPoint) else {
//    completion(.failure(.invalidUsername))
//    return
//  }
//
//  let task = URLSession.shared.dataTask(with: url) { data, response, error in
//    if let _ = error {
//      completion(.failure(.unableToComplete)); return
//    }
//
//    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//      completion(.failure(.invalidResponse)); return
//    }
//
//    guard let data else { completion(.failure(.invalidData)); return }
//
//    do {
//      let decoder = JSONDecoder()
//      // decoder.keyDecodingStrategy = .convertFromSnakeCase
//      decoder.dateDecodingStrategy = .iso8601
//      let user = try decoder.decode(User.self, from: data)
//      completion(.success(user))
//    } catch {
//      completion(.failure(.invalidData))
//    }
//  }
//
//  task.resume()
//}
