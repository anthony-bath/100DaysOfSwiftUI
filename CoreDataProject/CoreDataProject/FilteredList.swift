//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Anthony Bath on 5/25/23.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest, id: \.self) { entity in
            self.content(entity)
        }
    }
    
    init(filterKey: String, filterValue: String, content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
        )
        
        self.content = content
    }
}
