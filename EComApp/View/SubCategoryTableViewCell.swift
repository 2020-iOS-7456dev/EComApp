//
//  SubCategoryTableViewCell.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak private var buttonCheckbox: UIButton!
    @IBOutlet weak private var labelSubCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: setup Cell data from CategoryViewModel, SelectedCategoryViewModel
    func setupCellData(categoryVM: CategoryViewModel, selectedCategoryVM: SelectedCategoryViewModel) {
        self.labelSubCategoryName.text = categoryVM.name
        
        if selectedCategoryVM.categoryList.count == 0 {
            buttonCheckbox.isSelected = false
        }
        for category in selectedCategoryVM.categoryList {
            if categoryVM.id == category.id {
                buttonCheckbox.isSelected = true
                return
            } else {
                buttonCheckbox.isSelected = false
            }
        }
    }
}
