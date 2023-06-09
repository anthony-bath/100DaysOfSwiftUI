//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Anthony Bath on 5/17/23.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var orderData: OrderData
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingError = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityHidden(true)
                
                Text("Your total is \(orderData.order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text("Sorry, your order submission failed")
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(orderData) else {
            print("Failed to encode Order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(OrderData.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.order.quantity)x \(Order.types[decodedOrder.order.type].lowercased()) cupcakes is on it's way!"
            
            showingConfirmation = true
        } catch {
            print("Checkout failed")
            showingError = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(orderData: OrderData())
        }
    }
}
