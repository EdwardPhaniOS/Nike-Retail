//
//  ProductDetailTVC.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/18/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class ProductDetailTVC: UITableViewController
{   //When product did set, reload data of table view and pageViewController based on the new product object, then scroll to the top of table view
    var product: Product! {
        didSet {
            self.tableView.reloadData()
            
            let pViewController = self.children[0] as! ProductImagesPageViewController
            pViewController.product = self.product
            pViewController.turnToPage(index: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    @IBOutlet weak var productImagesHeaderView: ProductImagesHeaderView!
    
    struct StoryBoard {
        static let productDetailCell = "ProductDetailCell"
        static let buyButtonCell = "BuyButtonCell"
        //        static let showProductDetailSegue = "ShowProductDetailSegue"
        static let showProductDetailCell = "ShowProductDetailCell"
        static let showImagesPageViewController = "ShowImagesPageViewController"
        static let suggestionCell = "SuggestionTableViewCell"
        static let suggestionCollectionViewCell = "SuggestionCollectionViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(product.name!)"
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == 3 {
            if let cell = cell as? SuggestionTableViewCell {
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.collectionView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoard.showImagesPageViewController
        {
            if let imagesPageVC = segue.destination as? ProductImagesPageViewController {
                imagesPageVC.product = self.product
                imagesPageVC.pageViewControllerDelegate = productImagesHeaderView
            }
        }
    }
    
    // MARK: - TableView Data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.productDetailCell, for: indexPath) as! ProductDetailCell
            cell.product = product
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.buyButtonCell, for: indexPath) as! BuyButtonCell
            cell.product = product
            cell.delegate = self
            return cell
            
        } else  if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.showProductDetailCell, for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.suggestionCell, for: indexPath) as! SuggestionTableViewCell
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return tableView.bounds.width + 68
        }
        return UITableView.automaticDimension
    }
    
}

//MARK: - UICollectionView Datasource

extension ProductDetailTVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryBoard.suggestionCollectionViewCell, for: indexPath) as! SuggestionCollectionViewCell
        
        if let product = self.product, let relatedUID = product.relatedProductUID {
            cell.productUID = relatedUID[indexPath.item]
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProductDetailTVC: UICollectionViewDelegate
{
    //When user tap on a product on UICollectionView, we can get the correnspose product object. Then we pass that product object to ProductDetailVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let product = self.product, let relatedUID = product.relatedProductUID {
            let productID = relatedUID[indexPath.item]
        
            FIRDatabaseReference.products(uid: productID).reference().observeSingleEvent(of: .value) { (snapshot) in
                if let productDict = snapshot.value as? [String : Any] {
                    let selectedProduct = Product(dictionary: productDict)
                    self.product = selectedProduct
                }
            }
        }
    }
}

extension ProductDetailTVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 2.0
            let itemWidth = (collectionView.bounds.width - 5.0) / 2.0
            
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
        return CGSize()
    }
}

extension ProductDetailTVC: BuyButtonCellDelegate
{
    func showAlert() {
        let alert = UIAlertController(title: "Success", message: "Item is added to your cart", preferredStyle: .alert)
        let keepShoppingAction = UIAlertAction(title: "Keep shopping", style: .default) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let checkoutAction = UIAlertAction(title: "Check out", style: .default) { (_) in            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CheckOutNavigationController")
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
        alert.addAction(keepShoppingAction)
        alert.addAction(checkoutAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addToCart(product: Product) {
        ShoppingCart.add(product: product)
    }
    
}

