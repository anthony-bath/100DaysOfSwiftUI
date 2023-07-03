//
//  ContentView.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RollView()
                .tabItem {
                    Label("Your Dice", systemImage: "dice.fill")
                }
            
            Text("HistoryView")
                .tabItem( {
                    Label("Roll History", systemImage: "chart.bar.doc.horizontal")
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
