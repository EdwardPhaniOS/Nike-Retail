//
//  ProductImagesPageViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/22/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

protocol ProductImagesPageViewControllerDelegate: class
{
    func setUpPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}

class ProductImagesPageViewController: UIPageViewController {
    
    var product: Product!
    
    weak var pageViewControllerDelegate: ProductImagesPageViewControllerDelegate?
    
    struct StoryBoard {
        static let productImageViewController = "ProductImageViewController"
    }
    
    lazy var controllers: [UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controllers = [UIViewController]()
        
        if let imageLinks = self.product.imageLinks {
            for imageLink in imageLinks {
                let productImageVC = storyboard.instantiateViewController(withIdentifier: StoryBoard.productImageViewController)
                controllers.append(productImageVC)
            }
        }
        self.pageViewControllerDelegate?.setUpPageController(numberOfPages: controllers.count)
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // UIScrollView.ContentInsetAdjustmentBehavior.never
        dataSource = self
        delegate = self
        
        self.turnToPage(index: 0)
    }
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewController.NavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)
            if currentIndex! > index {
                direction = .reverse
            }
        }
        
        configureDisplaying(viewController: controller)
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated() {
            if viewController == vc {
                if let productImageVC = viewController as? ProductImageViewController {
                    productImageVC.imageLink = self.product.imageLinks?[index]
                    self.pageViewControllerDelegate?.turnPageController(to: index)
                }
            }
        }
    }
}

extension ProductImagesPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    
    //MARK: - UIViewController DataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            }
        }
        
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        
        return controllers.first
    }
    
    //MARK: - UIViewController Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.configureDisplaying(viewController: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !finished
        {
            self.configureDisplaying(viewController: previousViewControllers.first!)
        }
    }
    
}

