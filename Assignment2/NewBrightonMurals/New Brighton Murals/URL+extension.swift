//
//  URL+extension.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 03/12/2022.
//

import UIKit


extension URL {
    
    
    // MARK: - dowload the image from the url in background thread and send it back with closure in main thread
    
    func downloadImage(completionHandler: @escaping ((UIImage?) -> ())) {
        let urlSessionDataTask = URLSession.shared.dataTask(with: self) { data, response, error in
            guard
                let data = data,
                    error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completionHandler(image)
            }
        }
        urlSessionDataTask.resume()
    }
    
}
