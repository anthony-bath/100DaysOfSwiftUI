//
//  RollView.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import SwiftUI

struct RollView: View {
    let DiceValues = [6, 10, 12, 20, 100]
    @State private var die = [Dice]()
    @State private var isEditing = false
    
    
    private var columns: [GridItem] {
        if die.count == 1 || die.count == 3 {
            return [GridItem(.flexible())]
        }
        
        return [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if die.count > 0 {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 100
                    ) {
                        ForEach(die) { dice in
                            VStack {
                                HStack {
                                    if isEditing {
                                        Image(systemName: "chevron.left")
                                            .onTapGesture { updateDice(dice, direction: -1) }
                                    }
                                    
                                    Text("\(dice.value)")
                                        .frame(width: 64, height: 64)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.primary, lineWidth: 2)
                                        )
                                    
                                    if isEditing {
                                        Image(systemName: "chevron.right")
                                            .onTapGesture { updateDice(dice, direction: 1) }
                                    }
                                }
                                
                                if isEditing {
                                    Button(role: .destructive) {
                                        die.removeAll { $0 == dice }
                                        
                                        if die.count == 0 {
                                            isEditing = false
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle")
                                    }
                                    .padding(.top, 5)
                                }
                            }
                            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                                .onEnded { value in
                                    if isEditing {
                                        switch(value.translation.width, value.translation.height) {
                                        case (...0, -30...30):
                                            updateDice(dice, direction: -1)
                                            break;
                                            
                                        case (0..., -30...30):
                                            updateDice(dice, direction: 1)
                                        default: break;
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.bottom, 75)
                    
                    
                    if !isEditing {
                        Button {
                            
                        } label: {
                            Label("Roll", systemImage: "dice.fill")
                        }
                        .padding()
                        .padding([.leading,.trailing])
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        )
                    }
                } else {
                    Text("Add a Dice to get started!")
                }
            }
            .toolbar {
                if die.count > 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation { isEditing.toggle() }
                        } label: {
                            Text(isEditing ? "Done" : "Edit")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addDice()
                    } label: {
                        Label("Add Dice", systemImage: "plus.square")
                    }
                    .disabled(die.count == 6)
                }
            }
            .navigationTitle("Your Dice")
            .onAppear { die = DiceLoader().load() }
        }
    }
    
    func updateDice(_ dice: Dice, direction: Int) {
        let currentValueIndex = DiceValues.firstIndex(of: dice.value) ?? 0
        var nextIndex = currentValueIndex + direction
        
        if nextIndex < 0 { nextIndex = DiceValues.count - 1 }
        if nextIndex == DiceValues.count { nextIndex = 0}
        
        let newValue = DiceValues[nextIndex]
        let newDice = Dice(id: dice.id, value: newValue)
        
        let currentDiceIndex = die.firstIndex(of: dice) ?? 0
        
        withAnimation {
            die.remove(at: currentDiceIndex)
            die.insert(newDice, at: currentDiceIndex)
        }
        
        DiceSaver().save(die)
    }
    
    func addDice() {
        die.append(Dice())
        DiceSaver().save(die)
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}
