//
//  UserDetailView.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/30/23.
//

import SwiftUI

struct UserDetailView: View {
    var user: User
    var users: [User]
    
    var body: some View {
        List {
            Section {
                Text(user.about)
            } header: {
                Text("About")
            }
            
            Section {
                Text(user.email)
            } header: {
                Text("E-Mail")
            }
            
            Section {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(user.tags, id: \.self) { tag in
                            Text(tag)
                                .frame(minWidth: 50)
                                .padding(10)
                                .background(Capsule().fill(Color.gray.opacity(0.5)))
                                .foregroundColor(.primary)
                                .bold()
                        }
                    }
                }
                
            } header: {
                Text("Tags")
            }
            
            Section {
                ForEach(user.friends, id: \.id) { friend in
                    NavigationLink(value: getUser(id: friend.id)) {
                        Text(friend.name)
                    }
                }
            } header: {
                Text("Friends")
            }
        }
        .navigationBarTitle(user.name)
    }
    
    func getUser(id: UUID) -> User {
        users.first { $0.id == id }!
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static let users = User.sampleUsers
    
    static var previews: some View {
        NavigationStack {
            UserDetailView(user: users[0], users: users)
        }
    }
}