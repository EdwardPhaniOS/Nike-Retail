//
//  CheckoutTableViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Stripe

class CheckoutTableViewController: UITableViewController {
    
    var products: [Product]?
    var billingInfo: BillingInformation?
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    struct Storyboard {
        static let creditCardInformationCell = "CreditCardInformationCell"
        static let cartDetailCell = "CartDetailCell"
        static let totalCell = "TotalCell"
        static let submitOrder = "SubmitOrder"
        static let billingInformation = "BillingInformation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CHECK OUT"
        updateUI()
        self.tableView.allowsSelection = false
    }
    
    func updateUI()
    {
        if products != nil {
            let shoppingCart = ShoppingCart(products: products!)
            if let subTotal = shoppingCart.subTotal,
                let shipping = shoppingCart.shipping,
                let tax = shoppingCart.tax,
                let total = shoppingCart.total {
                
                if shipping == 0 {
                    shippingLabel.text = "FREE"
                } else {
                    shippingLabel.text = "$\(shipping)"
                }
                
                subTotalLabel.text = "$\(subTotal)"
                taxLabel.text =  "$\(tax)"
                totalLabel.text = "$\(total)"
            }
        }
    }
    
    // MARK: - Table view Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    // MARK: - Target / Action
    
    @IBAction func submitOrderDidTap()
    {
        if emailAddressTextField.text != "" && cardNumberTextField.text != ""
            && cvcTextField.text != ""
        {
            billingInfo?.cardNumber = cardNumberTextField.text!
            billingInfo?.cVC = cvcTextField.text!
            billingInfo?.expirationDate = expirationDatePicker.date
            billingInfo?.emailAdress = emailAddressTextField.text!
            showAlert(message: "", title: "Success", isDone: true)
           
        } else {
             showAlert(message: "Your billing information is missing", title: "Oops!", isDone: false)
        }
        
    }
    
    func showAlert(message: String, title: String, isDone: Bool)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if isDone == true {
                let initViewController = self.storyboard?.instantiateInitialViewController()
                self.navigationController?.present(initViewController!, animated: true, completion: nil)
            }
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}


