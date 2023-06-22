//
//  ContentView.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .onTapGesture { selectedTab = 2}
                .tabItem {
                    Label("One", systemImage: "star")
                }
                .tag(1)
                
            
            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "trash")
                }
                .tag(2)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
