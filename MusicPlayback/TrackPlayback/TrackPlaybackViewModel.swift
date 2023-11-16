//
//  TrackPlaybackViewModel.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import Foundation

class TrackPlaybackViewModel {
  
  private(set) var trackData: TrackData
  
  var isPlaying: Bool = false
  
  init(trackData: TrackData) {
    self.trackData = trackData
  }
  
  func updatetrack(trackData: TrackData) {
    self.isPlaying = false
    self.trackData = trackData
  }
  
}
