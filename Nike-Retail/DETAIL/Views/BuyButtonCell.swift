//
//  BuyButtonCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/18/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

protocol BuyButtonCellDelegate: class
{
    func addToCart(product: Product) -> Void
    func showAlert() -> Void
}

class BuyButtonCell: UITableViewCell {
    
    @IBOutlet weak var buyButton: UIButton!
    var product: Product? {
        didSet {
            self.updateUI()
        }
    }
    
    weak var delegate: BuyButtonCellDelegate?
    
    func updateUI()
    {
        if let product = product {
            self.buyButton.setTitle("BUY $\(product.price!)", for: [])
        }
        
    }
    
    @IBAction func buyButtonDidTap()
    {
        delegate?.addToCart(product: self.product!)
        delegate?.showAlert()
    }
}
