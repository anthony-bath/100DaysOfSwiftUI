//
//  User.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/28/23.
//

import Foundation

struct User: Codable, Hashable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int16
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    init(name: String, friends: [Friend]) {
        self.id = UUID()
        self.isActive = true
        self.name = name
        self.age = 23
        self.company = "TestCo"
        self.email = "user@testco.com"
        self.address = "123 Fake St"
        self.about = "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt."
        self.registered = Date.now
        self.tags = ["Some", "Tag"]
        self.friends = friends
    }
    
    static var sampleUsers: [User] {
        let user1 = User(name: "Richard Branson", friends: [])
        let user2 = User(name: "Tim Robbins", friends: [Friend(id: user1.id, name: user1.name)])
        let user3 = User(name: "Bill White", friends: [Friend(id: user2.id, name: user2.name)])
        
        return [user3, user2, user1]
    }
}

struct Friend: Codable, Hashable {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
