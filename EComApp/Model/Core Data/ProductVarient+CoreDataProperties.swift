//
//  ProductVarient+CoreDataProperties.swift
//  
//
//  Created by Raj Kadam on 04/06/20.
//
//

import Foundation
import CoreData


extension ProductVarient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductVarient> {
        return NSFetchRequest<ProductVarient>(entityName: "ProductVarient")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int16
    @NSManaged public var price: Int32
    @NSManaged public var size: Int16

}
