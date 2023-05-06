//
//  ContentView.swift
//  Moonshot
//
//  Created by Anthony Bath on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showListView: Bool = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if (showListView) {
                    ListContentView(missions: missions)
                } else {
                    GridContentView(missions: missions)
                }
            }
            .navigationTitle("Moonshot")
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(showListView ? "Grid View" : "List View") {
                    showListView.toggle()
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
