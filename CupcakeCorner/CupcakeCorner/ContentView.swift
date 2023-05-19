//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Anthony Bath on 5/16/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var orderData = OrderData()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your Cake Type", selection: $orderData.order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(orderData.order.quantity)", value: $orderData.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests", isOn: $orderData.order.specialRequestEnabled.animation())
                    
                    if orderData.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $orderData.order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $orderData.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(orderData: orderData)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
