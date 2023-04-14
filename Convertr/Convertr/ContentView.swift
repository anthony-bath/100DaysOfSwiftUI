//
//  ContentView.swift
//  Convertr
//
//  Created by Anthony Bath on 4/13/23.
//

import SwiftUI

enum Unit: String, Equatable, CaseIterable {
    case m = "m"
    case ft = "ft"
    case yard = "yard"
    case km = "km"
    case mi = "mi"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct ContentView: View {
    @State private var value: Double = 0;
    @State private var fromUnit: Unit = .m
    @State private var toUnit: Unit = .mi
    @FocusState private var valueIsFocused: Bool
    
    var factors: [Unit : [Unit : Double]] = [
        .m: [
            .m : 1,
            .ft : 3.28084,
            .yard : 1.09361,
            .km : 0.001,
            .mi : 0.000621371
        ],
        .ft: [
            .m : 0.3048,
            .ft: 1,
            .yard : 0.333333,
            .km : 0.0003048,
            .mi : 0.000189394
        ],
        .yard: [
            .m : 0.9144,
            .ft : 3,
            .yard : 1,
            .km : 0.0009144,
            .mi : 0.000568182
        ],
        .km : [
            .m : 1000,
            .ft : 3280.84,
            .yard: 1093.61,
            .km : 1,
            .mi : 0.621371
        ],
        .mi : [
            .m : 1609.34,
            .ft : 5280,
            .yard : 1760,
            .km : 1.60934,
            .mi : 1
        ]
    ]
    
    var convertedValue : String {
        let factor : Double = factors[fromUnit]?[toUnit] ?? 0
        let result = value * factor
        
        return "\(value.formatted()) \(fromUnit.rawValue) is \(result.formatted()) \(toUnit.rawValue)"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Value", value: $value, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($valueIsFocused)
                } header: {
                    Text("Value to Convert")
                }
                
                Section {
                    Picker("From Units", selection: $fromUnit) {
                        ForEach(Unit.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("From Units")
                }
                
                Section {
                    Picker("From Units", selection: $toUnit) {
                        ForEach(Unit.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("To Units")
                }
                
                Section {
                    Text(convertedValue)
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Convertr")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        valueIsFocused = false
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
