//
//  ShoppingCart.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 6/24/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import Foundation
import Firebase

public let vnTaxPercentage = 0.1
public let freeShippingLimit = 50.00
public let defaultShippingFee = 5.99

class ShoppingCart
{
    var products: [Product]?
    var subTotal: Double?
    var shipping: Double?
    var tax: Double?
    var total: Double?
    
    init(products: [Product]?) {
        self.products = products
        
        let calculator = Calculator(products: products)
        
        subTotal = calculator.subTotal
        shipping = calculator.shippingFee
        tax = calculator.tax
        total = calculator.total
    }
    
    class func add(product: Product)
    {
        let currentUser = Auth.auth().currentUser
        let ref = FIRDatabaseReference.users(uid: currentUser!.uid).reference().child("shoppingCart")
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            //get the latest data of shoppingCart
            //as a productsDict object type [String : Any]
            var cart = currentData.value as? [String : Any] ?? [:]
            var productsDict = cart["products"] as? [String : Any] ?? [:]
            
            //update productsDict object with the new added product
            productsDict[product.uid!] = product.toDictionary()
            
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
            
            if subTotal >= freeShippingLimit || subTotal == 0 {
                shipping = 0
            } else {
                shipping = defaultShippingFee
            }
            
            tax = (subTotal + shipping) * vnTaxPercentage
            total = subTotal + shipping + tax
            
            //update back the values to shoppingCart
            cart["subTotal"] = subTotal
            cart["shipping"] = shipping
            cart["tax"] = tax
            cart["total"] = total
            cart["products"] = productsDict
            
            //return back the value of currentData as a new updated cart - so we can upload this to our firebase
            currentData.value = cart
            return TransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapShot) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    class func fetchSelectedProducts(completion: @escaping ([Product]?) -> Void)
    {
        var selectedProducts = [Product]()
        
        let currentUser = Auth.auth().currentUser
        let ref = FIRDatabaseReference.users(uid: currentUser!.uid).reference().child("shoppingCart")
        
        ref.observe(.value) { (snapShot) in
            selectedProducts.removeAll()
            var cartDict = snapShot.value as? [String : Any] ?? [:]
            let productsDict = cartDict["products"] as? [String : Any] ?? [:]
            
            for (_, productDict) in productsDict {
                let product = Product(dictionary: productDict as! [String : Any])
                selectedProducts.append(product)
            }
            completion(selectedProducts)
        }
    }
}

