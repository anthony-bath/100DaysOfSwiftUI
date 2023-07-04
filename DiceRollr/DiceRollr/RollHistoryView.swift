//
//  RollHistoryView.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/4/23.
//

import SwiftUI

struct RollHistoryView: View {
    var rolls: [Roll]
    var onDelete: (Roll) -> Void
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(rolls) { roll in
                    HStack {
                        Text("\(roll.total)")
                            .frame(width: 50, height: 50, alignment: .center)
                            .overlay(
                                Circle()
                                    .stroke(.primary, lineWidth: 2)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(roll.date.formatted())
                                .padding(.bottom)
                            
                            Grid(verticalSpacing: 5) {
                                GridRow {
                                    Text("Dice").bold()
                                    Text("\(roll.dice.map(String.init).joined(separator: ","))")
                                }
                                GridRow {
                                    Text("Rolls").bold()
                                    Text("\(roll.rolls.map(String.init).joined(separator: ","))")
                                }
                            }
                            
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            onDelete(roll)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Rolls")
        }
    }
}

struct RollHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RollHistoryView(
            rolls: [Roll(dice: [100,100,100,100,100,100], rolls: [100,100,100,100,100,100])],
            onDelete: { _ in }
        )
    }
}
