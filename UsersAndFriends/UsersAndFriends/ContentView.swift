//
//  ContentView.swift
//  UsersAndFriends
//
//  Created by Anthony Bath on 5/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var users: [User] = [User]()
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                NavigationLink(value: user) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(user.isActive ? .green : .gray)
                        .padding(.trailing, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.name)
                            
                            Text(user.email)
                                .font(.caption)
                        }
                        .frame(alignment: .leading)
                    }
                }
            }
            .padding(.bottom, 10)
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                UserDetailView(user: user, users: users)
            }
        }
        .task {
            if users.isEmpty {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")
            let (data, response) = try await URLSession.shared.data(from: url!)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Non-200 Status Code")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                users = try decoder.decode([User].self, from: data)
            } catch {
                print("JSON decode failed: \(error.localizedDescription)")
            }
        } catch {
            print("Download failed: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
