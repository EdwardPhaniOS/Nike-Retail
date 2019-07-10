//
//  ViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

/*
 H1: Design Nike Data Structure
 What?
 1. Your app UI
 2. Features in your app
 
 How?
 H2: class Product
    uid: String
    Name: String
    Images: [UIImage]
    Price: Double
    Description: String
    Detail: String
    relatedProductUID: [String]?
 
    ..protype data..
 
 H1: class BillCalculator
 
 
 H1: Prototype
 
    =HomeTab=
    ProductsTableViewController
    ProductDetailTVC
    -
    ProductTableViewCell
    ProductInformationCell
    BuyButtonCell
    ProductDetailCells
    RelatedProductsCells
 
 
    =Shopping bag tab=
    ShoppingBagTVC
    NumberOfItemsCell
    ProductCell
    SubtotalCell
    TotalCell
    CheckoutButtonCell
 
    -
    CheckoutTVC
    BillingLabelCell
    CreditCardInformationCell
    SubmitOrderCell
 
 
*/

