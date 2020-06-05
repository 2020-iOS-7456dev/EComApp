//
//  VariantCollectionViewCell.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class VariantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var labelColor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: setup Cell data from ProductViewModel
    func setCellData(productViewModel: ProductViewModel) {
        
        self.labelColor.text = productViewModel.color
        
        if productViewModel.isCurrentVariantSelected {
            labelColor.layer.borderColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.7).cgColor
        } else {
            labelColor.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
