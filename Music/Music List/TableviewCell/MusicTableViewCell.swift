//
//  MusicTableViewCell.swift
//  Music
//
//  Created by Ankit Bansal on 08/02/21.
//

import UIKit
import Kingfisher

class MusicTableViewCell: UITableViewCell {

    // MARK: Cell Interface Builder Outlets
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: Display Cell Data
    
    func setCellData(trackInfo: TrackInfo) {
        songName.text = trackInfo.trackName.label
        artistName.text = trackInfo.trackArtist.label
        if let imageUrl = trackInfo.trackImages.first?.label {
            let url = URL(string: imageUrl )
            imageThumbnail.kf.setImage(with: url)
        }
    }
}
