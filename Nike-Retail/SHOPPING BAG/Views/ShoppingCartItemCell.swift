//
//  ShoppingCartItemCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/2/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

protocol ShoppingCartItemCellDelegate: class
{
    func removeProduct(product: Product) -> Void
}

class ShoppingCartItemCell: UITableViewCell
{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var product: Product? {
        didSet {
            updateUI()
        }
    }

    var delegate: ShoppingCartItemCellDelegate?
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func updateUI() {
        if let product = product
        {
            self.productNameLabel?.text = product.name
            self.priceLabel?.text = "$ \(product.price!)"
    
            if let imageLink = product.featureImageLink
            {
                if let featureImage = imageCache.object(forKey: imageLink as AnyObject) as? UIImage {
                    self.updateImage(image: featureImage)
                } else {
                    FIRImage.downloadImage(uri: imageLink) { (image, error) in
                        if error == nil && image != nil {
                            self.imageCache.setObject(image!, forKey: imageLink as AnyObject)
                            self.updateImage(image: image!)
                        } else {
                            print("Download feature Image error")
                        }
                    }
                }
            }
            
        }
    }
    
    func updateImage(image: UIImage)
    {
        self.productImageView.image = image
        self.setNeedsLayout()
    }
  
    @IBAction func removeProductDidTouch(_ sender: Any)
    {
        if let product = self.product {
            self.delegate?.removeProduct(product: product)
        }

    }
}
