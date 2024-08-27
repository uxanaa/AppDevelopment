//
//  NewBrightonMural.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 26/11/2022.
//

import UIKit
import CoreLocation


// MARK: - I used refrence type to have instant change between all refrences.

class Mural: Decodable {
    let id, title: String
    let artist, info: String?
    let thumbnail: String?
    let lat, lon: String?
    let enabled, lastModified: String
    let images: [Image]?
    
    
    // MARK: - define all the decoding keys for the dictionary to separate from class property
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist, info, thumbnail, lat, lon,enabled, lastModified, images
    }
    
    
    // MARK: - to track the status of image to avoid downloading each time tableview reloading
    
    var thumbnailImage = ImageState.initiated
    var isFavorite = false
    
    
    // MARK: - return thumbnail Url from thumbnail string if it has a value
    
    lazy var thumbnailUrl: URL? = {
        guard let thumbnail = thumbnail else { return nil }
        return URL(string: thumbnail)
    }()
    
    
    // MARK: - return coordinate from lat and long string if those have values

    lazy var coordinate: CLLocation? = {
        guard
            let latString = lat,
            let longString = lon,
            let lat = Double(latString),
            let long = Double(longString)
        else { return nil }
        return CLLocation(latitude: lat, longitude: long)
    }()
    
}

