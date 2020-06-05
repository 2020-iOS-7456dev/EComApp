//
//  ProductListProtocol.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation

protocol ProductListProtocol: class {
    func success()
    func failure()
    func filterProducts(selecteCategoryViewModel: SelectedCategoryViewModel)
}
