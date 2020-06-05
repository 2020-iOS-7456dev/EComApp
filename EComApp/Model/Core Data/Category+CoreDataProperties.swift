//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Raj Kadam on 04/06/20.
//
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var childCategories: [Int]?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var parentCategoryId: Int16
    @NSManaged public var products: Set<Product>?

}

// MARK: Generated accessors for products
extension Category {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
