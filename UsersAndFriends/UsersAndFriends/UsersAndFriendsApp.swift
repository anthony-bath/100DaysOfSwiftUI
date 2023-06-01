//
//  UsersAndFriendsApp.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/28/23.
//

import SwiftUI

@main
struct UsersAndFriendsApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
