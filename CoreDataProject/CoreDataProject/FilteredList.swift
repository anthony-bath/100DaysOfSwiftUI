//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Anthony Bath on 5/25/23.
//

import SwiftUI
import CoreData

enum Predicate: String {
    case beginsWith
    case contains
    case endsWith
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest, id: \.self) { entity in
            self.content(entity)
        }
    }
    
    init(filterKey: String, filterValue: String, predicate: Predicate, content: @escaping (T) -> Content) {
        let predicateString = "\(predicate.rawValue.uppercased())[C]"
        
        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "\(filterKey) \(predicateString) '\(filterValue)'")
        )
        
        self.content = content
    }
}
