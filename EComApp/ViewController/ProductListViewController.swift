//
//  ProductListViewController.swift
//  EComApp
//
//  Created by Raj Kadam on 03/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    fileprivate let cellPaddingSpace: CGFloat = 20
    fileprivate let cellHeight: CGFloat = 238
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let productCellIdentifier = "ProductCollectionViewCell"
    fileprivate let filterSegueIdentifier = "listToFilterSortView"
    fileprivate let productDetailsSegueIdentifier = "toProductDetails"
    fileprivate var productList: [Product] = []
    fileprivate let productListVM = ProductListViewModel()
    
    fileprivate var selectedCategoryList = [Category]()
    fileprivate var selectedSort: SortTypes?
    fileprivate var selectedProduct: Product?
    
    lazy fileprivate var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak private var productListCollectionView: UICollectionView! {
        didSet {
            productListCollectionView.refreshControl = refreshControl
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerNibs()
        fetchProducts()
    }
    
    // MARK: - fetchProducts Method
    /**
     This method checks if the products are availabel in local DB
     if not it wil call the API 
     */
    func fetchProducts() {
        productListVM.delegate = self
        if let list = productListVM.getAllProducts(), list.count > 0 {
            productList = list
            self.productListCollectionView.reloadData()
        } else {
            RKActivityIndicator.show("loading...")
            productListVM.getProductListAPI()
        }
        
    }
    
    // MARK: - pull To Refresh Method
    /**
     This method  fetch the fresh data From API
     */
    @objc private func pullToRefresh() {
        RKActivityIndicator.show("loading...")
        self.productListVM.getProductListAPI()
    }
    
    // MARK: - Register Nib Method
    /**
     This method  registers required cell with Collectionview
     */
    func registerNibs() {
        self.productListCollectionView.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: productCellIdentifier)
        
    }
    
    // MARK: - Filter Action Method
    /**
     This method open Filter controller
     */
    @IBAction func filterAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: filterSegueIdentifier, sender: nil)
    }
    
    // MARK: - Sort Action Method
    /**
     This method open the Action sheet controller
     to  display the sorting options
     */
    @IBAction func sortAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sort by: ", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constant.AlertActions.mostViewdProduct, style: .default) { (_) in
            self.setupSortedProducts(productSortType: .mostViewdProdcuts)
        })
        
        alert.addAction(UIAlertAction(title: Constant.AlertActions.mostOrderedProduct, style: .default) { (_) in
            self.setupSortedProducts(productSortType: .mostOrderedProducts)
        })
        
        alert.addAction(UIAlertAction(title: Constant.AlertActions.mostSharedProduct, style: .default) { (_) in
            self.setupSortedProducts(productSortType: .mostSharedProducts)
        })
        
        alert.addAction(UIAlertAction(title: Constant.AlertActions.allProdcutsAToZ, style: .default) { (_) in
            self.setupSortedProducts(productSortType: .allProducts)
        })
        
        alert.addAction(UIAlertAction(title: Constant.AlertActions.cancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    // MARK: - Product Sorting  Method
    /**
     This method sorts the products according to input type
     */
    fileprivate func setupSortedProducts(productSortType: SortTypes) {
        selectedSort = productSortType
        switch productSortType {
        case .mostViewdProdcuts:
            productList = productList.sorted {
                $0.viewCount > $1.viewCount
            }
        case.mostOrderedProducts:
            productList = productList.sorted {
                $0.orderCount > $1.orderCount
            }
        case .mostSharedProducts:
            productList = productList.sorted {
                $0.shares > $1.shares
            }
            
        case .allProducts:
            productList = productList.sorted {
                $0.name < $1.name
            }
        }
        productListCollectionView.reloadData()
        productListCollectionView.scrollToTop()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.destination.isKind(of: FilterSortViewController.self) {
            let destination_vc = segue.destination as! FilterSortViewController
            destination_vc.delegate = self
            destination_vc.selectedCategories = selectedCategoryList
        }
        if segue.destination.isKind(of: ProductDetailsViewController.self) {
            let destination_vc = segue.destination as! ProductDetailsViewController
            
            destination_vc.currentProduct = selectedProduct
        }
    }
}

// MARK: - Collection View Delegate , Datasource Extension
/**
 fetch data from local DB and
 Set product cells accordingly
 */

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
        let productViewModel = ProductViewModel(productData: productList[indexPath.item], sortType: selectedSort, variant: productList[indexPath.item].variants?.first)
        cell.setProductData(productViewModel: productViewModel)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedProduct = productList[indexPath.row]
        self.performSegue(withIdentifier: productDetailsSegueIdentifier, sender: nil)
    }
    
}

// MARK: - CollectionView FlowLayout Delegate Extension
/**
 set Collection cell 2:2
 
 */
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = cellPaddingSpace * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - CGFloat(paddingSpace)
        let cellWidth = availableWidth / itemsPerRow
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}

// MARK: - ProductListProtocol Delegate Extension
/**
 
 
 */
extension ProductListViewController: ProductListProtocol {
    
    // MARK: - Filter product Delegate Method
    /**
     FilterSortViewController returns this method with Filtered Categories
     fetch the products from the filtered categories and set it to current CollectionView
     */
    func filterProducts(selecteCategoryViewModel: SelectedCategoryViewModel) {
        
        selectedCategoryList = selecteCategoryViewModel.categoryList
        if selectedCategoryList.count == 0 {
            if let list = productListVM.getAllProducts() {
                productList = [Product]()
                productList = list
            }
        } else {
            self.productList = [Product]()
            for category in selectedCategoryList {
                guard let products = category.products else {return}
                productList.append(contentsOf: products)
            }
        }
        if let sort = selectedSort {
            setupSortedProducts(productSortType: sort)
        }
        productListCollectionView.reloadData()
        productListCollectionView.scrollToTop()
    }
    
    // MARK: - API Call Success Delegate Method
    /**
     Once successfully received data from API And storing it to local DB
     This Method Fetch all product data from local DB and display on screen
     */
    func success() {
        
        RKActivityIndicator.dismiss()
        selectedCategoryList = [Category]()
        if let list = productListVM.getAllProducts() {
            productList = [Product]()
            productList = list
        }
        productListCollectionView.reloadData()
        productListCollectionView.scrollToTop()
        hideRefreshingControl()
    }
    
    // MARK: - API Call Failure Delegate Method
    /**
     This method hides the activity controller and dismiss the Refreshing controller
     */
    func failure() {
        RKActivityIndicator.dismiss()
        hideRefreshingControl()
    }
    // MARK: - Hide Refresh Control Method
    /**
     Dismiss the Refreshing controller
     */
    func hideRefreshingControl() {
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }
    }
}
