//
//  CachedUser+CoreDataProperties.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 6/1/23.
//
//

import Foundation
import CoreData


extension CachedUser {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
        return NSFetchRequest<CachedUser>(entityName: "CachedUser")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var company: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?
    
    public var wId: UUID {
        id ?? UUID()
    }
    
    public var wName: String {
        name ?? "Unknown Name"
    }
    
    public var wEmail: String {
        email ?? "Not Available"
    }
    
    public var wTags: [String] {
        tags?.components(separatedBy: ",") ?? [String]()
    }
    
    public var wAbout: String {
        about ?? "No Information Available"
    }
    
    public var wCompany: String {
        company ?? "Unknown Company"
    }
    
    public var wAddress: String {
        address ?? "Unkown Address"
    }
    
    public var friendsArray: [CachedFriend] {
        let set: Set<CachedFriend> = friends as? Set<CachedFriend> ?? []
        
        return set.sorted {
            $0.wName < $1.wName
        }
    }
    
    
}

// MARK: Generated accessors for friends
extension CachedUser {
    
    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: CachedFriend)
    
    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: CachedFriend)
    
    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)
    
    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)
    
}

extension CachedUser : Identifiable {
    
}
