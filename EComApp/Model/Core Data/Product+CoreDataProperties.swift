//
//  Product+CoreDataProperties.swift
//
//
//  Created by Raj Kadam on 04/06/20.
//
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: Int16
    @NSManaged public var viewCount: Int32
    @NSManaged public var orderCount: Int32
    @NSManaged public var shares: Int32

    @NSManaged public var name: String
    @NSManaged public var variants: Set<ProductVarient>?
    @NSManaged public var tax: ProductTax?

}

// MARK: Generated accessors for variants
extension Product {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: ProductVarient)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: ProductVarient)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
