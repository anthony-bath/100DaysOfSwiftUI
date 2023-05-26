//
//  Country+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Anthony Bath on 5/25/23.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var candy: NSSet?
    
    public var wFullName: String {
        fullName ?? "Unknown"
    }
    
    public var wShortName: String {
        shortName ?? "Unknown"
    }
    
    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted { $0.wName < $1.wName }
    }

}

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

extension Country : Identifiable {

}
