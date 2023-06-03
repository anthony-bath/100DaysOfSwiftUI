//
//  UserDetailView.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/30/23.
//

import SwiftUI

struct UserDetailView: View {
    var user: CachedUser
    var users: FetchedResults<CachedUser>
    
    var body: some View {
        List {
            Section {
                Text(user.wAbout)
            } header: {
                Text("About")
            }
            
            Section {
                Text(user.wEmail)
            } header: {
                Text("E-Mail")
            }
            
            Section {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(user.wTags, id: \.self) { tag in
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
                ForEach(user.friendsArray, id: \.wId) { friend in
                    NavigationLink(value: getUser(id: friend.wId)) {
                        Text(friend.wName)
                    }
                }
            } header: {
                Text("Friends")
            }
        }
        .navigationBarTitle(user.wName)
    }
    
    func getUser(id: UUID) -> CachedUser {
        users.first { $0.wId == id }!
    }
}
