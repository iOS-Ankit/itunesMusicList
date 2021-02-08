//
//  MusicDetailViewController.swift
//  Music
//
//  Created by Ankit Bansal on 08/02/21.
//

import UIKit
import AVFoundation
import Kingfisher

class MusicDetailViewController: UIViewController {
    
    // MARK: Interface Builder Outlets
    
    @IBOutlet weak var volSlider: UISlider!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var musicThumbnail: UIImageView!
    @IBOutlet weak var seekMinlabel: UILabel!
    @IBOutlet weak var seekMaxlabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var repeatMusicBtn: UIButton!
    
    @IBOutlet weak var songNamelabel: UILabel!
    @IBOutlet weak var artistNamelabel: UILabel!
    @IBOutlet weak var albumNamelabel: UILabel!
    @IBOutlet weak var releaseDatelabel: UILabel!
    @IBOutlet weak var albumPricelabel: UILabel!
    
    // MARK: Interface Builder Properties
    
    var player: AVPlayer?
    var selectedIndex: TrackInfo?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        player = nil
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        self.title = selectedIndex?.trackName.label ?? ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        if let imageUrl = selectedIndex?.trackImages.last?.label {
            let url = URL(string: imageUrl )
            musicThumbnail.kf.setImage(with: url)
        }
        
        self.songNamelabel.text = selectedIndex?.title.label
        self.artistNamelabel.text = selectedIndex?.trackArtist.label
        self.releaseDatelabel.text = selectedIndex?.trackReleaseDate.attributes.label
        self.albumPricelabel.text = "\(selectedIndex?.trackPrice.label ?? "") \(selectedIndex?.trackPrice.attributes.currency ?? "")"
        self.albumNamelabel.text = selectedIndex?.trackCollection.albumName.label ?? ""
    }
    
    // MARK: Play Music
    
    func playMusic() {
        if let playableItem = selectedIndex?.link.filter({$0.attributes.href.contains(".m4a")}).first {
            self.initializePlayer(playableItem.attributes.href)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.player?.play()
        }
    }
    
    func initializePlayer(_ playableItem: String) {
        if player != nil {
            player = nil
        }
        
        if let url = URL(string: playableItem) {
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                if self.player!.currentItem?.status == .readyToPlay {
                    self.updateTime()
                }
            })
        }
    }
    
    func updateTime() {
        // Access current item
        if let currentItem = self.player?.currentItem {
            // Get the current time in seconds
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            // Format seconds for readable text
            trackSlider.minimumValue = 0
            trackSlider.value = Float(playhead)
            trackSlider.maximumValue = Float(duration)
            self.seekMinlabel.text = formatTimeFor(seconds: playhead)
            self.seekMaxlabel.text = formatTimeFor(seconds: duration)
            
            if self.seekMinlabel.text == self.seekMaxlabel.text {
                repeatMusicBtn.isHidden = false
                playPauseBtn.isHidden = true
                trackSlider.value = 0
                self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.seekMinlabel.text = "0.00"
                self.seekMaxlabel.text = formatTimeFor(seconds: duration)
                player?.pause()
            }
        }
    }
    
    // MARK: Handel Duration
    
    func getHoursMinutesSecondsFrom(_ seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    // MARK: Interface Builder Actions
    
    @IBAction func playPauseButton(sender: UIButton) {
        if player != nil {
            if player?.timeControlStatus == .playing {
                self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                player?.pause()
            } else {
                self.playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                player?.play()
            }
        } else {
            self.playMusic()
        }
    }
    
    @IBAction func repeatMusicButton(sender: UIButton) {
        repeatMusicBtn.isHidden = true
        playPauseBtn.isHidden = false
        self.playMusic()
    }
    
    @IBAction func trackSliderAction(_ sender: UISlider) {
        if player != nil {
            if let _ = self.player?.currentItem {
                let seconds = sender.value
                player?.seek(to: CMTimeMakeWithSeconds(Float64(seconds), preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }
    }
    
    @IBAction func volumeSliderAction(_ sender: UISlider) {
        player?.volume = Float(sender.value)/10
    }
    
    @IBAction func volumeMinAction(_ sender: UIButton) {
        player?.volume = 0
        volSlider.value = 0
    }
    
    @IBAction func volumeMaxAction(_ sender: UIButton) {
        player?.volume = 10
        volSlider.value = 10
    }
    
}
