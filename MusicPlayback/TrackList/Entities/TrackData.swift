//
//  TrackData.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import Foundation

struct TrackData: Codable {
  let trackName: String
  let trackId: Double
  let artistName: String
  let kind: String
  let previewUrl: URL?
  let artworkUrl100: URL?
  let shortDescription: String?
  let trackTimeMillis: Double?
  let primaryGenreName: String
  let collectionName: String?
}
