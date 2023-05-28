//
//  User.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/28/23.
//

import Foundation

struct User: Codable {
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
}

struct Friend: Codable {
    var id: UUID
    var name: String
}
