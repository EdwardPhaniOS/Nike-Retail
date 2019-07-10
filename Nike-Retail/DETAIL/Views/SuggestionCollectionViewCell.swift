//
//  SuggestionCollectionViewCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/1/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    var productUID: String!
    {
        didSet {
            FIRImage.getImageUriOf(productUID: productUID) { (uri) in
                guard let uri = uri else { return }
                
                if let featureImage = self.imageCache.object(forKey: uri as AnyObject) as? UIImage {
                    self.image = featureImage
                } else {
                    FIRImage.downloadImage(uri: uri, completion: { (image, error) in
                        if error == nil && image != nil {
                            self.image = image
                            self.imageCache.setObject(image!, forKey: uri as AnyObject)
                        } else {
                            print("Error")
                        }
                    })
                }
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
            setNeedsLayout()
        }
    }
    
}
