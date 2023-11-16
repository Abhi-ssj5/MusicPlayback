//
//  TrackTableViewCell.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
  
  @IBOutlet private var title: UILabel!
  
  @IBOutlet private var artist: UILabel!
  
  @IBOutlet private var album: UILabel!
  
  @IBOutlet private var duration: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
    self.selectionStyle = .none
  }
  
  func configure(data: TrackData) {
    
    title.text = data.trackName
    artist.text = data.artistName
    album.text = data.collectionName
    album.isHidden = data.collectionName == nil
    duration.text = String(data.trackTimeMillis ?? 0.0 / 1000) + " seconds"
  }
  
}
