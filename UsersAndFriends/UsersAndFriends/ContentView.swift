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
                Text(user.name)
            }
            .padding(.bottom, 10)
            .navigationTitle("Users")
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
                
                let decodedResponse = try decoder.decode([User].self, from: data)
                users = decodedResponse
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
