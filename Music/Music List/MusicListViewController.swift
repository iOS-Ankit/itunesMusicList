//
//  MusicListViewController.swift
//  Music
//
//  Created by Ankit Bansal on 08/02/21.
//

import UIKit

class MusicListViewController: UIViewController {

    // MARK: Interface Builder Outlets
    
    @IBOutlet weak var musiclistTblVw: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Interface Builder Properties
    
    var tracks = [TrackInfo]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTraks()
    }
    
    // MARK: Traks API
    
    func fetchTraks() {
        activityIndicator.startAnimating()
        let vm = MusicViewModel()
        vm.apiToFetchTracks { (music, error)  in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                if let trackList = music?.feed.entry {
                    self.tracks = trackList
                    self.musiclistTblVw.reloadData()
                } else {
                    print(error ?? "Something went wrong")
                }
            }
        }
    }
    
    // MARK: Navigation
    
    func navigateToMusicDetail(_ selectedIndex: TrackInfo) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
        destinationVC.selectedIndex = selectedIndex
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        cell.setCellData(trackInfo: self.tracks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = self.tracks[indexPath.row]
        self.navigateToMusicDetail(selectedIndex)
    }
}

