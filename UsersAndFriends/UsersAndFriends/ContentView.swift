//
//  ContentView.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/28/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var cachedUsers: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationStack {
            List(cachedUsers, id: \.id) { user in
                NavigationLink(value: user) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(user.isActive ? .green : .gray)
                        .padding(.trailing, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.wName)
                            
                            Text(user.wEmail)
                                .font(.caption)
                        }
                        .frame(alignment: .leading)
                    }
                }
            }
            .padding(.bottom, 10)
            .navigationTitle("Users")
            .navigationDestination(for: CachedUser.self) { user in
                UserDetailView(user: user, users: cachedUsers)
            }
        }
        .task {
            if cachedUsers.isEmpty {
                print("Downloading Users")
                if let users = await fetchData() {
                    await MainActor.run {
                        for user in users {
                            let cachedUser = CachedUser(context: moc)

                            cachedUser.id = user.id
                            cachedUser.name = user.name
                            cachedUser.email = user.email
                            cachedUser.about = user.about
                            cachedUser.registered = user.registered
                            cachedUser.tags = user.tags.joined(separator: ",")
                            cachedUser.address = user.address
                            cachedUser.age = Int16(user.age)
                            cachedUser.company = user.company
                            cachedUser.isActive = user.isActive

                            for friend in user.friends {
                                let newFriend = CachedFriend(context: moc)

                                newFriend.id = friend.id
                                newFriend.name = friend.name
                                cachedUser.addToFriends(newFriend)
                            }

                            do {
                                try moc.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
            else {
                print("Loading Users From Core Data")
                // Uncomment to delete all Users
//                for user in cachedUsers {
//                    moc.delete(user)
//                }
//
//                try? moc.save()
            }
        }
    }
    
    func fetchData() async -> [User]? {
        print("Downloading")
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")
            let (data, response) = try await URLSession.shared.data(from: url!)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Non-200 Status Code")
                return nil
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                return try decoder.decode([User].self, from: data)
            } catch {
                print("JSON decode failed: \(error.localizedDescription)")
            }
        } catch {
            print("Download failed: \(error.localizedDescription)")
        }
        
        return nil
    }
}
