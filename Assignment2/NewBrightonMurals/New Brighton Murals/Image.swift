//
//  Image.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 26/11/2022.
//

import UIKit



class Image: Codable {
    
    var imageState: ImageState = .initiated
    let id, filename: String
    var url: URL? {
        URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm_images/\(filename)")
    }
    
    // MARK: - define the keys for each image
    
    enum CodingKeys: String, CodingKey {
        case id, filename
    }
    
}
