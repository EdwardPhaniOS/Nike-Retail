//
//  FeedProductCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/16/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

//Caching
//CoreData
//Firebase offline mode
//Realm
//SAMCache

class FeedProductCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var product: Product? {
        didSet {
            self.updateUI()
        }
    }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func updateUI()
    {
        if let product = product {
            //download product image
            if let imageLinks = product.imageLinks, let imageLink = imageLinks.first {
                
                if let imageFromCache = imageCache.object(forKey: imageLink as AnyObject) as? UIImage {
                    updateImage(image: imageFromCache)
                } else {
                    FIRImage.downloadImage(uri: imageLink) { (image, error) in
                        if error == nil {
                            self.updateImage(image: image!)
                            self.imageCache.setObject(image!, forKey: imageLink as AnyObject)
                        } else {
                            print("Download Image Error")
                        }
                    }
                }
            }
            
            self.productNameLabel.text = product.name
            self.productPriceLabel.text = "$\(product.price!)"
        }
    }
    
    func updateImage(image: UIImage)
    {
        self.productImageView.image = image
        self.setNeedsLayout()
    }
}







