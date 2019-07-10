//
//  Calculator.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import Foundation

class Calculator
{
    var products: [Product]?
    var subTotal: Double
    var shippingFee: Double
    var tax: Double
    var total: Double
    
    init(products: [Product]?)
    {
        var totalBeforeTax = 0.0
        
        if let products = products
        {
            for product in products {
                totalBeforeTax = totalBeforeTax + product.price!
            }
            subTotal = totalBeforeTax
        } else {
            subTotal = 0.0
        }
        
        if totalBeforeTax > freeShippingLimit || totalBeforeTax == 0
        {
            self.shippingFee = 0
        } else {
            self.shippingFee = defaultShippingFee
        }
        
        self.tax = (totalBeforeTax + self.shippingFee) * vnTaxPercentage
        self.total = totalBeforeTax + self.shippingFee + self.tax
    }
    
}
