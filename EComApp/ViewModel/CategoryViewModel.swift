//
//  CategoryViewModel.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation
 
struct CategoryViewModel {
    
    private let category: Category
      
    public init(_ category: Category) {
        self.category = category
      }

      public var name: String? {
          return category.name
      }
    
    public var id: Int16? {
        return category.id
    }
    
}

struct SelectedCategoryViewModel {

    fileprivate let selectedCategoryList: [Category]

    public init(selectedCategories: [Category]) {
      self.selectedCategoryList = selectedCategories
    }
    
    public var categoryList: [Category] {
           return selectedCategoryList
       }

}
