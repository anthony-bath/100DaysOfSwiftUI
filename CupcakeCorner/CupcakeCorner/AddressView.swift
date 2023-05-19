//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Anthony Bath on 5/17/23.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var orderData: OrderData
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderData.order.name)
                TextField("Street Address", text: $orderData.order.streetAddress)
                TextField("City", text: $orderData.order.city)
                TextField("Zip", text: $orderData.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(orderData: orderData)
                } label: {
                    Text("Checkout")
                }
                .disabled(!orderData.order.hasValidAddress)
            }
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(orderData: OrderData())
        }
    }
}
