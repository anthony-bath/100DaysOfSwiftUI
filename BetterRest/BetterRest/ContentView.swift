//
//  ContentView.swift
//  BetterRest
//
//  Created by Anthony Bath on 4/20/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    private var idealBedTime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour+minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            return (wakeUp - prediction.actualSleep).formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
    
    static var defaultWakeTime: Date {
        let components = DateComponents(hour: 7, minute: 0)
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up")
                        .font(.headline)
                        .padding(.bottom,10)
                    
                    HStack {
                        Spacer()
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Spacer()
                    }
                    
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker(coffeeAmount == 1 ? "1 Cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ideal Bed Time")
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                        
                        Text(idealBedTime)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Better Rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
