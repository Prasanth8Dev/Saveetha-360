//
//  UIImageExtension.swift
//  Simats HRMS
//
//  Created by Admin - iMAC on 19/09/24.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string")
            return
        }

        // Create a URL session to fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for any errors or missing data
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data")
                return
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
