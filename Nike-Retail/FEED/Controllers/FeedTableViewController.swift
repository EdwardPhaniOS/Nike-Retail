//
//  FeedTableViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/16/19.
//  Copyright © 2019 PTV. All rights reserved.
//
//  Create Products Feed - Store Front

import UIKit
import Firebase

class FeedTableViewController: UITableViewController
{
    var products: [Product]?
    
    struct StoryBoard {
        static let feedProductCell = "FeedProductCell"
        static let showProductDetailSegue = "ShowProductDetailSegue"
        static let showWelcome = "ShowWelcome"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Products"
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //one-time sign-in - if the user logs in already or not
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //we do have the user. The user did log in
                //TODO: fetch products, update newsfeed
                self.fetchProducts()
            } else {
                //the user hasn't logged in or already logged out
                self.performSegue(withIdentifier: StoryBoard.showWelcome, sender: nil)
            }
        }
    }
    
    //MARK: - Fetching from Firebase
    
    func fetchProducts()
    {
        Product.fetchProducts { (products) in
            self.products = products
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logOutDidTap(_ sender: Any) {
        let firebaseAuth =  Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let products = products {
            return products.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.feedProductCell, for: indexPath) as! FeedProductCell
        
        if let products = products {
            cell.product = products[indexPath.row]
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    private var selectedProduct: Product?
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        if let products = products {
            self.selectedProduct = products[selectedIndex]
        }
        
        self.performSegue(withIdentifier: StoryBoard.showProductDetailSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoard.showProductDetailSegue
        {
            if let productDetailTVC = segue.destination as? ProductDetailTVC {
                productDetailTVC.product = selectedProduct
            }
        }
    }
}
