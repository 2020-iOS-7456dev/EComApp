//
//  ProductListModel.swift
//  EComApp
//
//  Created by Raj Kadam on 03/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation

struct ProductListModel: Codable {
    let categories: [CategoryData]
    let rankings: [RankingInfo]
}

struct CategoryData: Codable {
    let id: Int
    let name: String
    let products: [ProductDetails]
    let child_categories: [Int]?
    let tax: TaxData?
}

struct TaxData: Codable {
    let name: String
    let value: Double
    
}
struct ProductDetails: Codable {
    let id: Int
    let name: String
    let date_added: String
    let variants: [Variant]
    
}

struct Variant: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
}

struct RankingInfo: Codable {
    let ranking: String
    let products: [ProductData]
    
    struct ProductData: Codable {
        let id: Int
        let view_count: Int?
        let order_count: Int?
        let shares: Int?
    }

}
