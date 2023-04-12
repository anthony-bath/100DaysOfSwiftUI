//
//  ContentView.swift
//  WeSplit
//
//  Created by Anthony Bath on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10,15,20,25,0]
    
    var perPersonAmount: Double {
        let peopleCount = Double(numberOfPeople)
        let tipSelection = Double(tipPercentage)
        
        return (checkAmount * (100+tipSelection)/100) / peopleCount;
    }
    
    var totalCheckAmount: Double {
        return perPersonAmount * Double(numberOfPeople)
    }
    
    static let currencyCode = Locale.current.currency?.identifier ?? "USD"
    let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: currencyCode)
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Amount",
                        value: $checkAmount,
                        format: currencyFormat
                    )
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100, id: \.self) {
                            Text("\($0) People")
                        }
                    }
                }
                
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<100, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("Tip Percentage")
                }
                
                Section {
                    Text(totalCheckAmount, format: currencyFormat)
                } header: {
                    Text("Total Check Amount")
                }
                
                Section {
                    Text(perPersonAmount, format: currencyFormat)
                } header: {
                    Text("Amount Per Person")
                }
            }
            .navigationTitle("We Split")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
