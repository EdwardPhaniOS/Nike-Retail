//
//  ProductDetailCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/18/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    var product: Product? {
        didSet {
            productNameLabel.text = product?.name
            productDescriptionLabel.text = product?.description
        }
    }
    

}





