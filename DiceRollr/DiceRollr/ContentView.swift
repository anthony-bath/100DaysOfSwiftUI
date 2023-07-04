//
//  ContentView.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rolls = [Roll]()
    
    var body: some View {
        TabView {
            RollView(onRoll: recordRoll)
                .tabItem {
                    Label("Your Dice", systemImage: "dice.fill")
                }
            
            RollHistoryView(rolls: rolls, onDelete: removeRoll)
                .tabItem( {
                    Label("Roll History", systemImage: "chart.bar.doc.horizontal")
                })
        }
        .onAppear { rolls = RollLoader().load() }
    }
    
    func recordRoll(_ roll: Roll) {
        self.rolls.insert(roll, at: 0)
        RollSaver().save(rolls)
    }
    
    func removeRoll(_ roll: Roll) {
        self.rolls.removeAll { $0.id == roll.id }
        RollSaver().save(rolls)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
