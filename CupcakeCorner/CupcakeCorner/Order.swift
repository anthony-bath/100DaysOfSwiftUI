//
//  OrderNew.swift
//  CupcakeCorner
//
//  Created by Anthony Bath on 5/19/23.
//

import Foundation

class OrderData: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case order
    }
    
    @Published var order = Order()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(order, forKey: .order)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decode(Order.self, forKey: .order)
    }
    
    init() { }
}

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var extraFrosting = false
    var addSprinkles = false
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isBlank() || streetAddress.isBlank() || city.isBlank() || zip.isBlank() {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += (Double(type)) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += (Double(quantity) / 2)
        }
        
        return cost
    }
}

extension String {
    func isBlank() -> Bool {
        if (self.isEmpty) {
            return true
        }
        
        if (self.trimmingCharacters(in: .whitespaces).isEmpty) {
            return true
        }
        
        return false
    }
}
