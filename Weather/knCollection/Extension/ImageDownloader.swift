//
//  ImageDownloader.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 12/13/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(from url: String?, placeholder: UIImage? = nil,
                       completion: ((_ image: UIImage?) -> Void)? = nil) {
        
        guard let url = url, let nsurl = URL(string: url) else { return }
        kf.setImage(with: ImageResource(downloadURL: nsurl),
                    placeholder: placeholder,
                    completionHandler: { (image, _, _, _) in
                        
                        self.image = image
                        completion?(image)
        })
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let link = link else { return }
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
