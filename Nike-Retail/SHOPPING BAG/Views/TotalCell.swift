//
//  TotalCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var calculator: Calculator? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI()
    {
        if let calculator = calculator {
            self.totalPriceLabel?.text = "$ \(calculator.total)"
        }
    }

}
