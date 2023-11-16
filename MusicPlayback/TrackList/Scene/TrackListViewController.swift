//
//  TrackListViewController.swift
//  MusicPlayback
//
//  Created by Abhijeet Choudhary on 14/11/23.
//

import UIKit

class TrackListViewController: UIViewController {
  
  @IBOutlet private var tableView: UITableView!
  
  @IBOutlet private var activityLoader: UIActivityIndicatorView!
  
  // MARK: - Private properties
  
  private lazy var viewModel: TrackListViewModel = {
    return TrackListViewModel(networkClient: NetworkingClient())
  }()
  
  // MARK: - LifeCycle methods
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    
    viewModel.getTrackList(searchTerm: "jack johnson")
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - Private methods
  
  private func displayError(error: Error) {
    let alertView = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .destructive)
    alertView.addAction(action)
    self.present(alertView, animated: true)
  }
  
}

// MARK: - TrackListViewModelDelegate methods

extension TrackListViewController: TrackListViewModelDelegate {
  
  func handleGetTrackListSuccess(tracks: [TrackData]) {
    DispatchQueue.main.async {
      self.activityLoader.stopAnimating()
      self.tableView.reloadData()
    }
  }
  
  func handleGetTrackListFailure(error: Error) {
    DispatchQueue.main.async {
      self.activityLoader.stopAnimating()
      self.displayError(error: error)
    }
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tracks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath)
    if let cell = cell as? TrackTableViewCell {
      cell.configure(data: viewModel.tracks[indexPath.row])
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "TrackPlaybackViewController")
    guard let vc = viewController as? TrackPlaybackViewController else {
      return
    }
    vc.viewModel = TrackPlaybackViewModel(trackData: viewModel.tracks[indexPath.row])
    viewModel.selectedIndex = indexPath.row
    vc.delegate = self
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}

// MARK: - TrackPlaybackViewControllerDelegate methods

extension TrackListViewController: TrackPlaybackViewControllerDelegate {
  
  func getNextTrack() -> TrackData? {
    let nextIndex = viewModel.selectedIndex + 1
    if nextIndex < viewModel.tracks.count {
      viewModel.selectedIndex = nextIndex
      return viewModel.tracks[nextIndex]
    }
    else {
      return nil
    }
  }
  
  func getPreviousTrack() -> TrackData? {
    let nextIndex = viewModel.selectedIndex - 1
    if nextIndex >= 0 {
      viewModel.selectedIndex = nextIndex
      return viewModel.tracks[nextIndex]
    }
    else {
      return nil
    }
  }
  
}
