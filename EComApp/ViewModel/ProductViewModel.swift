//
//  ProductViewModel.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

struct ProductViewModel {

    private let product: Product
    private let sortOrder: SortTypes?
    let variant: ProductVarient?
    var selectedVariant: ProductVarient?
    
    public init(productData: Product, sortType: SortTypes?, variant: ProductVarient?) {
        self.product = productData
        self.sortOrder = sortType
        self.variant = variant
    }
    
    public var name: String? {
        return product.name
    }
    
    public var color: String {

           guard let variant = variant else {
            return ""
           }
        return variant.color?.uppercased() ?? ""

       }
    
    public var colorString: String {

        guard let variant = variant else {
            return ""
        }
        return "Color: \(variant.color ?? "NA")"

    }
    
   public var size: String {
        guard let variant = variant else {
            return ""
        }

        if variant.size != -1 {
            return "Size: \(variant.size)"
        }
        return ""

    }
    
    public var isCurrentVariantSelected: Bool {
        guard let productVariant = selectedVariant else {
            return false
        }
        if productVariant.id == variant?.id {
            return true
        } else {
            return false
        }
    }
    
    public var value: String {

           switch sortOrder {
           case .mostOrderedProducts:
               return "\(product.orderCount) Ordered"
           case .mostViewdProdcuts:
               return "\(product.viewCount) Viewed"
           case .mostSharedProducts:
               return "\(product.shares) Shared"
           default:
               return ""
           }

       }
    
    public var orderCount: String {
        return "\(product.orderCount)"
    }
    public var viewCount: String {
        return "\(product.viewCount)"
    }
    public var shareCount: String {
        return "\(product.shares)"
    }
    
    public var price: String? {
        
        guard let currentVariant = variant else {
            return nil
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_IN")
        
        return currencyFormatter.string(from: NSNumber(value: currentVariant.price))
        
    }
    
}
