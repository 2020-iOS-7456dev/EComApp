//
//  ProductCollectionViewCell.swift
//  EComApp
//
//  Created by Raj Kadam on 03/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var labelProductName: UILabel!
    @IBOutlet weak private var labelSize: UILabel!
    @IBOutlet weak private var labelColor: UILabel!
    @IBOutlet weak private var labelPrice: UILabel!
    @IBOutlet weak private var labelViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCellUI()
    }
    
    // MARK: Setup Initial Cell UI 
    fileprivate func setupCellUI() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
    }
   
    // MARK: Setup Product data from ProductViewModel
    func setProductData(productViewModel: ProductViewModel) {
        labelProductName.text = productViewModel.name
        labelPrice.text = productViewModel.price
        labelSize.text = productViewModel.size
        labelColor.text = productViewModel.colorString
        labelViews.text = productViewModel.value
    }
}
