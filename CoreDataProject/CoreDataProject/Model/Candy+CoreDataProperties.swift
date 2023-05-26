//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Anthony Bath on 5/25/23.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?
    
    public var wName: String {
        name ?? "Unknown Candy"
    }

}

extension Candy : Identifiable {

}
