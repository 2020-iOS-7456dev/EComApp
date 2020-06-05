//
//  VarientViewModel.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation

struct VarientViewModel {
    
    private let varient: ProductVarient
    private let productName: String?

    public init(name: String?, varient: ProductVarient) {
        self.productName = name
        self.varient = varient
    }
    
    public var name: String? {
        return productName
    }
    
    public var color: String? {
        return "Color: \(varient.color ?? "NA")"
    }

    public var size: String? {
                
        if varient.size > -1 {
            return "Size: \(varient.size)"
        }
        
        return "Size: NA"
    }
    
    public var formattedPrice: String? {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_IN")
        
        let price = currencyFormatter.string(from: NSNumber(value: varient.price))
        return "Price: \(price ?? "NA")"
        
    }
    
}
