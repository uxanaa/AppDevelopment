//
//  ImageState.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 10/12/2022.
//

import UIKit

// MARK: - defines all possible image states for when the image is downloaded
enum ImageState {
    case initiated, downloaded(image: UIImage), empty
}
