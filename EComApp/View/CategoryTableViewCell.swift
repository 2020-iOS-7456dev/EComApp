//
//  CategoryTableViewCell.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak private var labelCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Setup Product data from CategoryViewModel
    func setupCellData(categoryVM: CategoryViewModel) {
        self.labelCategoryName.text = categoryVM.name
    }
    
}
