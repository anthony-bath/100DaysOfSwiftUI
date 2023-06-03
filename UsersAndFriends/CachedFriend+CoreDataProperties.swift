//
//  CachedFriend+CoreDataProperties.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 6/1/23.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: CachedUser?
    
    public var wId: UUID {
        id ?? UUID()
    }
    
    public var wName: String {
        name ?? "Unknown Name"
    }

}

extension CachedFriend : Identifiable {

}
