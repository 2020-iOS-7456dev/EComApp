//
//  CoreDataManager.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSManagedObject {

     /// Returns the current managed object context.
     
     static var managedObjectContext: NSManagedObjectContext {
         return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     }
     
    /// Delete all objects from given entity.
    class func deleteAllFromEntity(entity: String) throws {
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try managedObjectContext.execute(batchDeleteRequest)
            
        } catch let deleteAllError {
            fatalError("Delete All Error for \(entity): \(deleteAllError)")
        }
        
        do {
            try managedObjectContext.save()
        } catch let deleteError {
            fatalError("Failed deleting \(deleteError)")
        }
    }

   /// Fetch Objects from given Entity
    class func fetch<T: NSManagedObject>(predicate: NSPredicate?=nil, sortDescriptor: NSSortDescriptor?=nil, entity: String) throws -> [T]? {

        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

            // Add predicate if any
            if let predicate = predicate {
                request.predicate = predicate
            }
            
            // Add sortDescriptor if any
            if let sortDescriptor = sortDescriptor {
                request.sortDescriptors = [sortDescriptor]
            }

            let fetchData = try managedObjectContext.fetch(request)
            return fetchData as? [T]
        
        } catch let fetchError {
            fatalError("Fetch Error for \(entity): \(fetchError)")
        }
        
    }
    
    // Save all products
    class func saveAllProducts(productModel: ProductListModel) {
        
        let categoryList = productModel.categories
        let rankingList = productModel.rankings
                
        for categoryData in categoryList {

            let categoryEntity = Category(context: managedObjectContext)
            categoryEntity.id = Int16(categoryData.id)
            categoryEntity.name = categoryData.name.trimmingCharacters(in: .whitespacesAndNewlines)
            categoryEntity.childCategories = categoryData.child_categories
            
            // Search parent cateogry
            let filteredList = categoryList.filter { (categoryObj) -> Bool in
                guard let childCategory = categoryObj.child_categories else { return false }
                return childCategory.contains(categoryData.id)
            }
            
            categoryEntity.parentCategoryId = Int16(filteredList.first?.id ?? -1)
            
            // Setting products
            let productList = createProductEntity(products: categoryData.products, rankingList: rankingList)
            categoryEntity.addToProducts(NSSet(array: productList))
            
        }
        
        do {
           try managedObjectContext.save()
          } catch let saveError {
           fatalError("Failed saving \(saveError)")
        }

    }

    private class func createProductVarientEntity(variants: [Variant]) -> [ProductVarient] {
        var variantEntityList = [ProductVarient]()
        
        for varient in variants {
            
            let varientEntity = ProductVarient(context: managedObjectContext)
            varientEntity.id = Int16(varient.id)
            varientEntity.size = Int16(varient.size ?? -1)
            varientEntity.color = varient.color
            varientEntity.price = Int32(varient.price)
            
            variantEntityList.append(varientEntity)
            
        }
        
        return variantEntityList
    }

    private class func createProductEntity(products: [ProductDetails], rankingList: [RankingInfo]) -> [Product] {
        var productList = [Product]()
        
        for product in products {
            
            let productEntity = Product(context: managedObjectContext)
            productEntity.id = Int16(product.id)
            productEntity.name = product.name
            
            for list in rankingList {
                
                if let firstProduct = (list.products.filter { $0.id == product.id}).first {
                    
                    if let orderCount = firstProduct.order_count {
                        productEntity.orderCount = Int32(orderCount)
                    }

                    if let viewCount = firstProduct.view_count {
                        productEntity.viewCount = Int32(viewCount)
                    }

                    if let shares = firstProduct.shares {
                        productEntity.shares = Int32(shares)
                    }

                }
                
            }
            
            // Setting product variant
            let productVarients = createProductVarientEntity(variants: product.variants)
            productEntity.addToVariants(NSSet(array: productVarients))

            productList.append(productEntity)
            
        }
        
        return productList
    }

}
