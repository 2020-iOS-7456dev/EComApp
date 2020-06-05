//
//  ProductDetailsViewController.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak private var labelProductName: UILabel!
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak private var labelSize: UILabel!
    @IBOutlet weak private var labelColor: UILabel!
    @IBOutlet weak private var labelPrice: UILabel!
    @IBOutlet weak private var labelViewCount: UILabel!
    @IBOutlet weak private var labelShareCount: UILabel!
    @IBOutlet weak private var labelOrderCount: UILabel!
    
    @IBOutlet weak private var variantCollectionView: UICollectionView!
    
    fileprivate let variantCellIdentifier = "VariantCollectionViewCell"
    
    fileprivate var variantArray = [ProductViewModel]()
    var currentProduct: Product?
    fileprivate var selectedIndexPath = IndexPath.init(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createVariantArray(currentVariantIndex: 0)
        registerNibs()
        dataSetup()
    }
    
    // MARK: - Creates the category Variants
    /**
     This method creates the variants list of the given product 
     */
    func createVariantArray(currentVariantIndex: Int) {
        guard let product = currentProduct else {
            return
        }
        variantArray = [ProductViewModel]()
        if let productVariants = product.variants {
            for variant in productVariants {
                var productVM =  ProductViewModel(productData: product, sortType: nil, variant: variant)
                productVM.selectedVariant = nil
                variantArray.append(productVM)
            }
            var productVar = variantArray[currentVariantIndex]
            productVar.selectedVariant = productVar.variant
            variantArray.remove(at: currentVariantIndex)
            variantArray.insert(productVar, at: currentVariantIndex)
        }
       
    }
    // MARK: - Register Nib Method
    /**
     This method  registers required cell with Collectionview
     */
    func registerNibs() {
        
        variantCollectionView.register(UINib.init(nibName: variantCellIdentifier, bundle: nil), forCellWithReuseIdentifier: variantCellIdentifier)
    }
    
    // MARK: - Product Details Data setup Method
    /**
     This method  sets the product data for different variants
     */
    func dataSetup() {
        let selectedVariant = variantArray[selectedIndexPath.row]
        self.labelProductName.text = selectedVariant.name
        self.labelPrice.text = selectedVariant.price ?? ""
        self.labelSize.text = selectedVariant.size
        
        self.labelOrderCount.text = selectedVariant.orderCount
        self.labelShareCount.text = selectedVariant.shareCount
        self.labelViewCount.text = selectedVariant.viewCount
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Collection View Delegate , Datasource Extension
/**
 Set product color variant cells
 */

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variantArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: variantCellIdentifier, for: indexPath) as! VariantCollectionViewCell
        cell.setCellData(productViewModel: variantArray[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        createVariantArray(currentVariantIndex: indexPath.row)
        
        UIView.performWithoutAnimation {
            self.variantCollectionView.reloadItems(at: [indexPath, self.selectedIndexPath])

        }
        selectedIndexPath = indexPath
        dataSetup()
    }
}
