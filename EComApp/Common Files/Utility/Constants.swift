//
//  Constants.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

struct ColorName {
    static let msgGreen = UIColor(red: 49.0/255.0, green: 159.0/255.0, blue: 71.0/255.0, alpha: 1.0)
    static let errorRed = UIColor(red: 1, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
}

struct Constant {
    struct AlertActions {
        static let mostViewdProduct = "Most Viewd Product"
        static let mostOrderedProduct = "Most Ordered Product"
        static let mostSharedProduct = "Most Shared Product"
        static let allProdcutsAToZ = "All Products Ascending"
        static let cancel = "Cancel"
    }
    struct ErrorMessages {
        static let noInternetMessage = "Please check your Internet connection."
    }
    
}

enum SortTypes {
    case mostViewdProdcuts
    case mostOrderedProducts
    case mostSharedProducts
    case allProducts
}
