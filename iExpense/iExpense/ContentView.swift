//
//  ContentView.swift
//  iExpense
//
//  Created by Anthony Bath on 4/29/23.
//

import SwiftUI

struct ExpenseItemView: View {
    var item: ExpenseItem
    
    static let currencyCode = Locale.current.currency?.identifier ?? "USD"
    let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: currencyCode)
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
            
            Text(item.amount, format: currencyFormat)
                .foregroundColor(getAmountColor(amount: item.amount))
        }
        .accessibilityElement()
        .accessibilityLabel("\(item.name), \(item.amount, format: .currency(code: "USD"))")
        .accessibilityHint("Type, \(item.type)")
    }
    
    func getAmountColor(amount: Double) -> Color {
        if (amount <= 10.0) { return Color.green }
        if (amount <= 100.0) { return Color.blue }
        
        return Color.black
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddView = false
    
    private var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    
    private var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if (personalExpenses.count > 0) {
                    Section {
                        ForEach(personalExpenses) { item in
                            ExpenseItemView(item: item)
                        }
                        .onDelete {
                            removeItems(at: $0, from: personalExpenses)
                        }
                    } header: {
                        Text("Personal")
                    }
                }
                
                if (businessExpenses.count > 0) {
                    Section {
                        ForEach(businessExpenses) { item in
                            ExpenseItemView(item: item)
                        }
                        .onDelete {
                            removeItems(at: $0, from: businessExpenses)
                        }
                    } header: {
                        Text("Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet, from collection: [ExpenseItem]) {
        let indexes = Array(offsets)
        var items = [ExpenseItem]()
        
        for i in 0..<collection.count {
            if indexes.contains(i) {
                items.append(collection[i])
            }
        }
        
        expenses.items.removeAll { item1 in
            items.contains { item2 in
                item2.id == item1.id
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
