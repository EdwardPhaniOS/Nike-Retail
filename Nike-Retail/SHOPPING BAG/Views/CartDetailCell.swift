//
//  CartDetailCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class CartDetailCell: UITableViewCell {
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var shippingFeeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    
    var calculator: Calculator? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI()
    {
        if let calculator = calculator {
            self.subTotalLabel?.text = "$ \(calculator.subTotal)"
            self.shippingFeeLabel?.text = calculator.shippingFee == 0 ? "FREE" : "$\(calculator.shippingFee)"
            self.taxLabel?.text = "$ \(calculator.tax)"
        }
        
    }
    
}
