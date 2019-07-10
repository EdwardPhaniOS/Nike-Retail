//
//  ShoppingBagTableViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/2/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Firebase

class ShoppingBagTableViewController: UITableViewController
{
    var products: [Product]?
    
    @IBAction func backButtonDidTap(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    struct Storyboard
    {
        static let numberOfItemsCell = "NumberOfItemsCell"
        static let itemCell = "ItemCell"
        static let cartDetailCell = "CartDetailCell"
        static let totalCell = "TotalCell"
        static let checkoutButtonCell = "CheckoutButtonCell"
        static let showCheckout = "ShowCheckout"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchShoppingCart()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchShoppingCart()
    {
        ShoppingCart.fetchSelectedProducts { (selectedProducts) in
            if let products = selectedProducts {
                self.products = products
                self.tableView.reloadData()
            } else {
                print("Error: Can not fetch products from shopping cart")
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCheckout {
            if let checkoutTVC = segue.destination as? CheckoutTableViewController {
                checkoutTVC.products = self.products
            }
        }
    }

    //MARK: - UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let products = products {
            return products.count + 4
        }
        return 1
    }
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let products = products else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = "0 ITEM"
            return cell
        }
        
        let calculator = Calculator(products: self.products)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = products.count == 1 ? "\(products.count) ITEM" : "\(products.count) ITEMS"
            return cell

        } else if indexPath.row <= products.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.itemCell, for: indexPath) as! ShoppingCartItemCell
            cell.product = products[indexPath.row - 1]
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        } else if indexPath.row == products.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cartDetailCell, for: indexPath) as! CartDetailCell
            cell.calculator = calculator
            return cell

        } else if indexPath.row == products.count + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.totalCell, for: indexPath) as! TotalCell
            cell.calculator = calculator
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.checkoutButtonCell, for: indexPath)
            return cell
        }
        
    }
}

extension ShoppingBagTableViewController: ShoppingCartItemCellDelegate {
    
    func removeProduct(product: Product)
    {
        let currentUser = Auth.auth().currentUser
        let ref = FIRDatabaseReference.users(uid: currentUser!.uid).reference().child("shoppingCart")
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            //get the latest data of shoppingCart
            //as a productsDict object type [String : Any]
            var cart = currentData.value as? [String : Any] ?? [:]
            var productsDict = cart["products"] as? [String : Any] ?? [:]
            
            //remove the selected product in productsDict object
            productsDict[product.uid!] = nil
            
            //re-calculate the detail of the shoppingCart
            //based on updated productsDict
            var subTotal: Double = 0
            var shipping: Double = 0
            var tax: Double = 0
            var total: Double = 0
            
            for (_, productDict) in productsDict {
                if let productDict = productDict as? [String : Any],
                    let price = productDict["price"] as? Double {
                    subTotal += price
                }
            }
            
            if subTotal >= 50.0 || subTotal == 0 {
                shipping = 0
            } else {
                shipping = 5.99
            }
            
            tax = (subTotal + shipping) * 0.1
            total = subTotal + shipping + tax
            
            //update back the values to the cart
            cart["subTotal"] = subTotal
            cart["shipping"] = shipping
            cart["tax"] = tax
            cart["total"] = total
            cart["products"] = productsDict
            
            //update back the currentData - then upload this to our firebase
            currentData.value = cart
            return TransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapShot) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}






