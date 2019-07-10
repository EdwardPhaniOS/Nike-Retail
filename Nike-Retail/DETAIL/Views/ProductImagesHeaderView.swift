//
//  ProductImagesHeader.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/29/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class ProductImagesHeaderView: UIView
{
    @IBOutlet weak var pageControl: UIPageControl!
}

extension ProductImagesHeaderView: ProductImagesPageViewControllerDelegate {
    func setUpPageController(numberOfPages: Int) {
        self.pageControl.numberOfPages = numberOfPages
    }
    
    func turnPageController(to index: Int) {
        self.pageControl.currentPage = index
    }
    
}
