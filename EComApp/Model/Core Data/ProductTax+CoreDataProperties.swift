//
//  ProductTax+CoreDataProperties.swift
//  
//
//  Created by Raj Kadam on 04/06/20.
//
//

import Foundation
import CoreData


extension ProductTax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductTax> {
        return NSFetchRequest<ProductTax>(entityName: "ProductTax")
    }

    @NSManaged public var name: String?
    @NSManaged public var tax: Double

}
