//
//  NetworkingClient.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import Foundation

class NetworkingClient {
  
  let urlSession: URLSession
  
  init() {
    urlSession = URLSession.shared
  }
  
  //https://itunes.apple.com/search?term=jack+johnson
  
  func getTrackList(term: String, completion: @escaping (Result<[TrackData], Error>) -> Void) {
    
    guard var url = URL(string: "https://itunes.apple.com/search") else {
      return completion(.failure(NetworkingError.invalidUrl))
    }
    
    url.append(queryItems: [URLQueryItem(name: "term", value: term)])
    
    let urlRequest = URLRequest(url: url)
    
    urlSession.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }
      else if let data = data {
        do {
          let decoder = JSONDecoder()
          let response = try decoder.decode(TrackList.self, from: data)
          completion(.success(response.results))
        }
        catch let error {
          completion(.failure(error))
        }
      }
      else {
        completion(.failure(NetworkingError.dataNotFound))
      }
    }.resume()
    
  }
  
}
