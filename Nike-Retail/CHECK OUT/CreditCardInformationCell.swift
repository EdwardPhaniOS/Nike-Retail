//
//  CreditCardInformationCell.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class CreditCardInformationCell: UITableViewCell {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var cVCTextField: UITextField!
    
    
    func resetUI()
    {
        emailAddressTextField?.text = ""
        cardNumberTextField?.text = ""
        expirationDatePicker?.date = Date()
        cVCTextField?.text = ""
    }
    
}
