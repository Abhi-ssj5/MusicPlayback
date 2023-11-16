//
//  TrackPlaybackViewController.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol TrackPlaybackViewControllerDelegate: AnyObject {
  
  func getNextTrack() -> TrackData?
  func getPreviousTrack() -> TrackData?
}

class TrackPlaybackViewController: UIViewController {
  
  @IBOutlet private var playPauseButton: UIButton!
  
  @IBOutlet private var backwardButton: UIButton!
  
  @IBOutlet private var forwardButton: UIButton!
  
  
  @IBOutlet private var thumbnailImage: UIImageView!
  
  @IBOutlet private var titleLabel: UILabel!
  
  @IBOutlet private var imageLoader: UIActivityIndicatorView!
  
  @IBOutlet private var volumeContainerView: UIView!
  
  // MARK: - Private properties
  
  private var player: AVPlayer?
  
  // MARK: - Public properties
  
  var viewModel: TrackPlaybackViewModel!
  
  weak var delegate: TrackPlaybackViewControllerDelegate?
  
  // MARK: - LifeCycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView(viewModel.trackData)
    setupPlayer(viewModel.trackData)
    setupVolumeView()
  }
  
  deinit {
    player?.pause()
    player = nil
  }
  
  // MARK: - Private methods
  
  private func setupView(_ data: TrackData) {
    titleLabel.text = data.trackName
    
    guard let url = data.artworkUrl100 else {
      return
    }
    
    self.imageLoader.startAnimating()
    URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] (data, _, error) in
      guard let self = self else {
        return
      }
      if let data = data {
        self.setupImage(data: data)
      }
      else {
        self.setupImage(data: nil)
      }
    }
    
  }
  
  private func setupImage(data: Data?) {
    DispatchQueue.main.async { [weak self] in
      self?.imageLoader.stopAnimating()
      if let data = data {
        self?.thumbnailImage.image = UIImage(data: data)
      }
      else {
        self?.thumbnailImage.image = nil
      }
    }
  }
  
  private func setupPlayer(_ data: TrackData) {
    guard let audioUrl = data.previewUrl else {
      return
    }
    
    player = AVPlayer(url: audioUrl)
  }
  
  private func setupVolumeView() {
    volumeContainerView.backgroundColor = .clear
    let volumeView = MPVolumeView(frame: volumeContainerView.bounds)
    volumeContainerView.addSubview(volumeView)
  }
  
  // MARK: - Button Actions
  
  @IBAction private func playPauseButtonAction(_ sender: UIButton) {
    guard let player = player else {
      return
    }
    
    playPauseButton.setTitle(viewModel.isPlaying ? "Play" : "Pause", for: .normal)
    
    if viewModel.isPlaying {
      player.pause()
    }
    else {
      player.play()
    }
    
    viewModel.isPlaying = !viewModel.isPlaying
  }
  
  @IBAction private func forwardButtonAction(_ sender: UIButton) {
    guard let track = delegate?.getNextTrack() else {
      return
    }
    
    player?.pause()
    player = nil
    playPauseButton.setTitle("Play", for: .normal)
    viewModel.updatetrack(trackData: track)
    setupView(track)
    setupPlayer(track)
  }
  
  @IBAction private func backwardButtonAction(_ sender: UIButton) {
    guard let track = delegate?.getPreviousTrack() else {
      return
    }
    
    player?.pause()
    player = nil
    playPauseButton.setTitle("Play", for: .normal)
    viewModel.updatetrack(trackData: track)
    setupView(track)
    setupPlayer(track)
  }
  
}
