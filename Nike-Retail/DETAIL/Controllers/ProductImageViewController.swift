//
//  ProductImageViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/22/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class ProductImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageLink: String? {
        didSet {
            if let imageLink = imageLink {
                FIRImage.downloadImage(uri: imageLink) { (image, error) in
                    if error == nil && image != nil {
                        self.imageView.image = image
                            self.activityIndicator.isHidden = true
                    } else {
                        print("Downloading image error: \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
}
