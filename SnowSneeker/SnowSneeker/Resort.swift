//
//  Resort.swift
//  SnowSneeker
//
//  Created by Anthony Bath on 7/5/23.
//

import Foundation

struct Resort: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    static let all: [Resort] = Bundle.main.decode("resorts.json")
    static let example = all[0]
}
