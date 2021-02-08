//
//  MusicModelFile.swift
//  Music
//
//  Created by Ankit Bansal on 08/02/21.
//

import Foundation

// MARK: Welcome
struct Music: Codable {
    let feed: Track
}

// MARK: Feed
struct Track: Codable {
    let entry: [TrackInfo]
}

// MARK: Entry
struct TrackInfo: Codable {
    let trackName: Description
    let trackImages: [Description]
    let trackCollection: TrackCollection
    let trackPrice: Price
    let title: Description
    let link: [Link]
    let trackArtist: Description
    let trackReleaseDate: ReleaseDate
    
    enum CodingKeys: String, CodingKey {
        case trackName = "im:name"
        case trackImages = "im:image"
        case trackCollection = "im:collection"
        case trackPrice = "im:price"
        case title, link
        case trackArtist = "im:artist"
        case trackReleaseDate = "im:releaseDate"
    }
}

struct TrackCollection: Codable {
    let albumName: Description
    
    enum CodingKeys: String, CodingKey {
        case albumName = "im:name"
    }
}

// MARK: IMArtist
struct Description: Codable {
    let label: String
}

// MARK: IMPrice
struct Price: Codable {
    let label: String
    let attributes: PriceAttributes
}

// MARK: IMPriceAttributes
struct PriceAttributes: Codable {
    let amount, currency: String
}

// MARK: IMReleaseDate
struct ReleaseDate: Codable {
    let attributes: Description
}

// MARK: Link
struct Link: Codable {
    let attributes: LinkAttributes
}

// MARK: LinkAttributes
struct LinkAttributes: Codable {
    let href: String
}

