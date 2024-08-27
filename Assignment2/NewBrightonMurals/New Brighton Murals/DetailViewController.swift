//
//  DetailViewController.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 10/12/2022.
//

import UIKit

class DetailViewController: UIViewController {

    var mural: Mural!

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // MARK: - set up detailViewController
        titleLabel.text = mural.title
        detailLabel.text = mural.artist
        if let image = mural.images?.first {
            if case .downloaded(let uiimage) = image.imageState {
                imageView.image = uiimage
            } else {
                download(image)
            }
        }
    }
    
    // MARK: - method to download image
    private func download(_ image: Image) {
        guard let url = image.url else { return }
        url.downloadImage { downloadedImage in
            guard let downloadedImage = downloadedImage else {
                self.mural.thumbnailImage = .empty
                return
            }
            image.imageState = .downloaded(image: downloadedImage)
            DispatchQueue.main.async {
                self.imageView.image = downloadedImage
            }
        }
    }

}
