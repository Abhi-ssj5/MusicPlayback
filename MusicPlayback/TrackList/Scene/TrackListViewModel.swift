//
//  TrackListViewModel.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import Foundation

protocol TrackListViewModelDelegate: AnyObject {
  func handleGetTrackListSuccess(tracks: [TrackData])
  func handleGetTrackListFailure(error: Error)
}

class TrackListViewModel {
  
  let networkClient: NetworkingClient
  
  private(set) var tracks: [TrackData] = []
  
  var selectedIndex: Int = -1
  
  weak var delegate: TrackListViewModelDelegate?
  
  init(networkClient: NetworkingClient) {
    self.networkClient = networkClient
  }
  
  func getTrackList(searchTerm: String) {
    networkClient.getTrackList(term: searchTerm) { [weak self] (result) in
      switch result {
      case .success(let tracks):
        self?.tracks = tracks
        self?.delegate?.handleGetTrackListSuccess(tracks: tracks)
        
      case .failure(let error):
        self?.delegate?.handleGetTrackListFailure(error: error)
      }
    }
  }
  
  
}
